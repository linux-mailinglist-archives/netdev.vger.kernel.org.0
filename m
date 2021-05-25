Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2FEB938FCEB
	for <lists+netdev@lfdr.de>; Tue, 25 May 2021 10:34:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231585AbhEYIfh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 25 May 2021 04:35:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50844 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231397AbhEYIfY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 25 May 2021 04:35:24 -0400
Received: from mail-qk1-x72c.google.com (mail-qk1-x72c.google.com [IPv6:2607:f8b0:4864:20::72c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D595CC06138C
        for <netdev@vger.kernel.org>; Tue, 25 May 2021 01:33:39 -0700 (PDT)
Received: by mail-qk1-x72c.google.com with SMTP id 76so29583387qkn.13
        for <netdev@vger.kernel.org>; Tue, 25 May 2021 01:33:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=3L2sKhYgVu4JHTo+b0EBVZURcIoWhyUynzpdSViL1vg=;
        b=TX3w0eqT+DQ95MJu6K78CoTtR67YpRyrV1CD/NWW2Ddy2rLbVKW9t/Cyvm1XvWT4pD
         X2kdjNokTKe9Y/UwVvb78/1WsVNGVq97p3+JZm+onDx8nmlR8B3vZ8SAN3zc7deyzdW2
         p7VffvOQSS4NqFxFc/VPgmVDXgHB2c95ebU6NJ4FenygYTeTiBIb6FGBct5S6pk2Ukg4
         LinenpPpSnwKGNYrgnAWIJazeicbljvHVcm8mdi04SCTrfbgOTaFS8zEyadhq94ElLQq
         boWr+AGK9MTeiCOTn8pKqtkovkHeYL8h4JUlzYkR0pjruByZTeH33MCHcqZ2DZ3ascGj
         8saw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=3L2sKhYgVu4JHTo+b0EBVZURcIoWhyUynzpdSViL1vg=;
        b=tTZRMfT6P4Ucws0bxcYxnDlHi61K8kYPjTD4HYpGuWFL+If1T71RDYMR0FGw9Aiukt
         t8SDFg576ib939O6ytkC8jkPUmhNI7+jbfjVERJqeDLyPpyzVdJevmH1+nbmduptAQ4z
         pgsohoFHK7yi8qiIpKU0S8Kqt01ACrP04j93YY5VRdYLJd9cHPl9bwr0pFoocO/Ua9Jy
         QUzroW6IAi7nOHs4vjzbrco0hRlsztfBvyKwCLL9nqsli0vmfdOps8OICCkPi3Zg0nhX
         KZ10lE60jqYrxpUDbZgv2NnATsrBv+xzp5SfWm/bV1KAabyeRUsgRV/VFbxrB367Sl4V
         CaXw==
X-Gm-Message-State: AOAM5318cQ4SKR9H1DZL/Ri/6kd3V0RwWikg0bMj2M0zsC5KNH6PWR3Y
        Lr6t9NPsh+/l7w+HwknDoNRiLAbooNbpnk3WH2w1uQ==
X-Google-Smtp-Source: ABdhPJxtyhJHguMpWiBB6pOik3m1zktEsKcwZ/KTQ6S9blI3sSHsEsjFb6qhbtYkbLgcxYZEH8H6d1wlpITXCAKGxi0=
X-Received: by 2002:a37:4694:: with SMTP id t142mr34598680qka.265.1621931618648;
 Tue, 25 May 2021 01:33:38 -0700 (PDT)
MIME-Version: 1.0
References: <000000000000f034fc05c2da6617@google.com> <CACT4Y+ZGkye_MnNr92qQameXVEHNc1QkpmNrG3W8Yd1Xg_hfhw@mail.gmail.com>
 <20210524041350.GJ4441@paulmck-ThinkPad-P17-Gen-1> <20210524224602.GA1963972@paulmck-ThinkPad-P17-Gen-1>
 <24f352fc-c01e-daa8-5138-1f89f75c7c16@windriver.com> <20210525033355.GN4441@paulmck-ThinkPad-P17-Gen-1>
In-Reply-To: <20210525033355.GN4441@paulmck-ThinkPad-P17-Gen-1>
From:   Dmitry Vyukov <dvyukov@google.com>
Date:   Tue, 25 May 2021 10:33:27 +0200
Message-ID: <CACT4Y+bkZv7uo505EBJcE1MLFG1GprZ5npdbaUXZ+ASTJyJU8A@mail.gmail.com>
Subject: Re: [syzbot] KASAN: use-after-free Read in check_all_holdout_tasks_trace
To:     "Paul E. McKenney" <paulmck@kernel.org>
Cc:     "Xu, Yanfei" <yanfei.xu@windriver.com>,
        syzbot <syzbot+7b2b13f4943374609532@syzkaller.appspotmail.com>,
        rcu@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
        Andrii Nakryiko <andrii@kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Jens Axboe <axboe@kernel.dk>, bpf <bpf@vger.kernel.org>,
        Christian Brauner <christian@brauner.io>,
        Daniel Borkmann <daniel@iogearbox.net>,
        John Fastabend <john.fastabend@gmail.com>,
        Martin KaFai Lau <kafai@fb.com>,
        KP Singh <kpsingh@kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        netdev <netdev@vger.kernel.org>,
        Shakeel Butt <shakeelb@google.com>,
        Song Liu <songliubraving@fb.com>,
        syzkaller-bugs <syzkaller-bugs@googlegroups.com>,
        Yonghong Song <yhs@fb.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, May 25, 2021 at 5:33 AM Paul E. McKenney <paulmck@kernel.org> wrote=
:
>
> On Tue, May 25, 2021 at 10:31:55AM +0800, Xu, Yanfei wrote:
> >
> >
> > On 5/25/21 6:46 AM, Paul E. McKenney wrote:
> > > [Please note: This e-mail is from an EXTERNAL e-mail address]
> > >
> > > On Sun, May 23, 2021 at 09:13:50PM -0700, Paul E. McKenney wrote:
> > > > On Sun, May 23, 2021 at 08:51:56AM +0200, Dmitry Vyukov wrote:
> > > > > On Fri, May 21, 2021 at 7:29 PM syzbot
> > > > > <syzbot+7b2b13f4943374609532@syzkaller.appspotmail.com> wrote:
> > > > > >
> > > > > > Hello,
> > > > > >
> > > > > > syzbot found the following issue on:
> > > > > >
> > > > > > HEAD commit:    f18ba26d libbpf: Add selftests for TC-BPF manag=
ement API
> > > > > > git tree:       bpf-next
> > > > > > console output: https://syzkaller.appspot.com/x/log.txt?x=3D17f=
50d1ed00000
> > > > > > kernel config:  https://syzkaller.appspot.com/x/.config?x=3D8ff=
54addde0afb5d
> > > > > > dashboard link: https://syzkaller.appspot.com/bug?extid=3D7b2b1=
3f4943374609532
> > > > > >
> > > > > > Unfortunately, I don't have any reproducer for this issue yet.
> > > > > >
> > > > > > IMPORTANT: if you fix the issue, please add the following tag t=
o the commit:
> > > > > > Reported-by: syzbot+7b2b13f4943374609532@syzkaller.appspotmail.=
com
> > > > >
> > > > > This looks rcu-related. +rcu mailing list
> > > >
> > > > I think I see a possible cause for this, and will say more after so=
me
> > > > testing and after becoming more awake Monday morning, Pacific time.
> > >
> > > No joy.  From what I can see, within RCU Tasks Trace, the calls to
> > > get_task_struct() are properly protected (either by RCU or by an earl=
ier
> > > get_task_struct()), and the calls to put_task_struct() are balanced b=
y
> > > those to get_task_struct().
> > >
> > > I could of course have missed something, but at this point I am suspe=
cting
> > > an unbalanced put_task_struct() has been added elsewhere.
> > >
> > > As always, extra eyes on this code would be a good thing.
> > >
> > > If it were reproducible, I would of course suggest bisection.  :-/
> > >
> > >                                                          Thanx, Paul
> > >
> > Hi Paul,
> >
> > Could it be?
> >
> >        CPU1                                        CPU2
> > trc_add_holdout(t, bhp)
> > //t->usage=3D=3D2
> >                                       release_task
> >                                         put_task_struct_rcu_user
> >                                           delayed_put_task_struct
> >                                             ......
> >                                             put_task_struct(t)
> >                                             //t->usage=3D=3D1
> >
> > check_all_holdout_tasks_trace
> >   ->trc_wait_for_one_reader
> >     ->trc_del_holdout
> >       ->put_task_struct(t)
> >       //t->usage=3D=3D0 and task_struct freed
> >   READ_ONCE(t->trc_reader_checked)
> >   //ops=EF=BC=8C t had been freed.
> >
> > So, after excuting trc_wait_for_one_reader=EF=BC=88=EF=BC=89, task migh=
t had been removed
> > from holdout list and the corresponding task_struct was freed.
> > And we shouldn't do READ_ONCE(t->trc_reader_checked).
>
> I was suspicious of that call to trc_del_holdout() from within
> trc_wait_for_one_reader(), but the only time it executes is in the
> context of the current running task, which means that CPU 2 had better
> not be invoking release_task() on it just yet.
>
> Or am I missing your point?
>
> Of course, if you can reproduce it, the following patch might be
> an interesting thing to try, my doubts notwithstanding.  But more
> important, please check the patch to make sure that we are both
> talking about the same call to trc_del_holdout()!
>
> If we are talking about the same call to trc_del_holdout(), are you
> actually seeing that code execute except when rcu_tasks_trace_pertask()
> calls trc_wait_for_one_reader()?
>
> > I investigate the trc_wait_for_one_reader=EF=BC=88=EF=BC=89 and found b=
efore we excute
> > trc_del_holdout, there is always set t->trc_reader_checked=3Dtrue. How =
about
> > we just set the checked flag and unified excute trc_del_holdout()
> > in check_all_holdout_tasks_trace with checking the flag?
>
> The problem is that we cannot execute trc_del_holdout() except in
> the context of the RCU Tasks Trace grace-period kthread.  So it is
> necessary to manipulate ->trc_reader_checked separately from the list
> in order to safely synchronize with IPIs and with the exit code path
> for any reader tasks, see for example trc_read_check_handler() and
> exit_tasks_rcu_finish_trace().
>
> Or are you thinking of some other approach?

This could be caused by a buggy extra put_pid somewhere else, right?
If so, I suspect that's what may be happening. We've 2 very similar
use-after-free reports on an internal kernel, but it also has a number
of other use-after-free reports in pid-related functions
(pid_task/pid_nr_ns/attach_pid). One of them is happening relatively
frequently (150 crashes) and is caused by something in the tty
subsystem. Presumably it may be causing one off use-after-free's in
other random places of the kernel as well. Unfortunately these crashes
don't happen on the upstream kernel (at least not yet).
So if you don't see any obvious smoking gun in rcu, I think we can
assume for now that it's due to tty.



>                                                         Thanx, Paul
>
> ------------------------------------------------------------------------
>
> diff --git a/kernel/rcu/tasks.h b/kernel/rcu/tasks.h
> index efb8127f3a36..2a0d4bdd619a 100644
> --- a/kernel/rcu/tasks.h
> +++ b/kernel/rcu/tasks.h
> @@ -987,7 +987,6 @@ static void trc_wait_for_one_reader(struct task_struc=
t *t,
>         // The current task had better be in a quiescent state.
>         if (t =3D=3D current) {
>                 t->trc_reader_checked =3D true;
> -               trc_del_holdout(t);
>                 WARN_ON_ONCE(READ_ONCE(t->trc_reader_nesting));
>                 return;
>         }
>
> --
> You received this message because you are subscribed to the Google Groups=
 "syzkaller-bugs" group.
> To unsubscribe from this group and stop receiving emails from it, send an=
 email to syzkaller-bugs+unsubscribe@googlegroups.com.
> To view this discussion on the web visit https://groups.google.com/d/msgi=
d/syzkaller-bugs/20210525033355.GN4441%40paulmck-ThinkPad-P17-Gen-1.
