Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C3DCD1A34F4
	for <lists+netdev@lfdr.de>; Thu,  9 Apr 2020 15:35:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726798AbgDINfP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 9 Apr 2020 09:35:15 -0400
Received: from mail-qv1-f68.google.com ([209.85.219.68]:38533 "EHLO
        mail-qv1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726741AbgDINfO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 9 Apr 2020 09:35:14 -0400
Received: by mail-qv1-f68.google.com with SMTP id p60so5450549qva.5
        for <netdev@vger.kernel.org>; Thu, 09 Apr 2020 06:35:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=/Vv+1R03DQVI7xYMxThrrmY4cHaZPeIPyuzJ14TmSL0=;
        b=Zp3NgtrQ1vfTTYfgW0xmuVmJgbKYkzCnOxiwfbVjlCreMgRQdn7dDxlqiWGHe9aQ66
         +CDMJBLuCagUM8RNHiyjFPH90w960p9forSKEIbCQVRKSQMgeLdDSRI/UzIf01+c6/D6
         SYeitg6zj6s2K6CL1nz68LwT3ZYYkE9LpOUmp5nns9tl3WjI6/eWOCTXxHooSNsgmPBe
         xaBtZsAJM1ZOnt4r5f9wPwJcK1tL+fr5dfocVUMWn4u5NbBOGGhAecFXUUiv9JPJ1NM/
         1QU1yx4wG9PFESYQO2TX1/J6A4rQkcQIQSEQBGRj33Qeo33JcdvgCGDPbqg7YGifoSlY
         ZJPA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=/Vv+1R03DQVI7xYMxThrrmY4cHaZPeIPyuzJ14TmSL0=;
        b=HMqRd4BLwfLEUvqqp2U+4cOPmjLHnV3Z+lqSFmuFzZ4fL9v7Id2Y0RdsivEm4Gc/vd
         v69CmRpNWM8V+98NRou1Tupizgt0/zxAHSVNTVuuFO6nFPSHRjTcJp3VWRjwfhle8RCw
         eHi3MREpHp1q5SqNyWV42LptJe8lrZ+j6wLmch4Ml49Yh1vqMk4Yy8QjhLoY1R4MxS4s
         aZH8jqKil+EnQaXfZiYwOsuJAeXsyyYCmjJ1rfrc2hQ1wdnlLwoUfG11e0nVXlyFNOOz
         rltJMmJGc1uxTon/bxgKD5Cdv9ZNIkKMwV9zS+J+irHR1cvOC3JtIMnbWXuTLVMrvj52
         dTdA==
X-Gm-Message-State: AGi0PubbXTJKfYre31eCxiov6kFLIVG+DQ3DTJpqYipcIJ1nfAcA+HfS
        EbpBhwc/NqPMfNyL6gr01h628FJ6H4MVfw771rKr/w==
X-Google-Smtp-Source: APiQypJ9AbNO5hodxrNmpo8tup2Sxro3VOnrszXIDpmLe7VEDvNIrpXgWp+m6E5XmJpzgPy0Fu8DZqcWuB//dPVOU2A=
X-Received: by 2002:a05:6214:434:: with SMTP id a20mr57329qvy.80.1586439314158;
 Thu, 09 Apr 2020 06:35:14 -0700 (PDT)
MIME-Version: 1.0
References: <00000000000075245205a2997f68@google.com> <20200406172151.GJ80989@unreal>
 <20200406174440.GR20941@ziepe.ca> <CACT4Y+Zv_WXEn6u5a6kRZpkDJnSzeGF1L7JMw4g85TLEgAM7Lw@mail.gmail.com>
 <20200407115548.GU20941@ziepe.ca> <CACT4Y+Zy0LwpHkTMTtb08ojOxuEUFo1Z7wkMCYSVCvsVDcxayw@mail.gmail.com>
 <20200407143528.GV20941@ziepe.ca>
In-Reply-To: <20200407143528.GV20941@ziepe.ca>
From:   Dmitry Vyukov <dvyukov@google.com>
Date:   Thu, 9 Apr 2020 15:35:02 +0200
Message-ID: <CACT4Y+bpms6+tPunsznx5_90Six_uicfx-_F2qctubmtBcq2Qw@mail.gmail.com>
Subject: Re: WARNING in ib_umad_kill_port
To:     Jason Gunthorpe <jgg@ziepe.ca>
Cc:     Leon Romanovsky <leon@kernel.org>,
        syzbot <syzbot+9627a92b1f9262d5d30c@syzkaller.appspotmail.com>,
        RDMA mailing list <linux-rdma@vger.kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        LKML <linux-kernel@vger.kernel.org>,
        netdev <netdev@vger.kernel.org>,
        Rafael Wysocki <rafael@kernel.org>,
        syzkaller-bugs <syzkaller-bugs@googlegroups.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Apr 7, 2020 at 4:35 PM Jason Gunthorpe <jgg@ziepe.ca> wrote:
>
> On Tue, Apr 07, 2020 at 02:39:42PM +0200, Dmitry Vyukov wrote:
> > On Tue, Apr 7, 2020 at 1:55 PM Jason Gunthorpe <jgg@ziepe.ca> wrote:
> > >
> > > On Tue, Apr 07, 2020 at 11:56:30AM +0200, Dmitry Vyukov wrote:
> > > > > I'm not sure what could be done wrong here to elicit this:
> > > > >
> > > > >  sysfs group 'power' not found for kobject 'umad1'
> > > > >
> > > > > ??
> > > > >
> > > > > I've seen another similar sysfs related trigger that we couldn't
> > > > > figure out.
> > > > >
> > > > > Hard to investigate without a reproducer.
> > > >
> > > > Based on all of the sysfs-related bugs I've seen, my bet would be on
> > > > some races. E.g. one thread registers devices, while another
> > > > unregisters these.
> > >
> > > I did check that the naming is ordered right, at least we won't be
> > > concurrently creating and destroying umadX sysfs of the same names.
> > >
> > > I'm also fairly sure we can't be destroying the parent at the same
> > > time as this child.
> > >
> > > Do you see the above commonly? Could it be some driver core thing? Or
> > > is it more likely something wrong in umad?
> >
> > Mmmm... I can't say, I am looking at some bugs very briefly. I've
> > noticed that sysfs comes up periodically (or was it some other similar
> > fs?).
>
> Hmm..
>
> Looking at the git history I see several cases where there are
> ordering problems. I wonder if the rdma parent device is being
> destroyed before the rdma devices complete destruction?
>
> I see the syzkaller is creating a bunch of virtual net devices, and I
> assume it has created a software rdma device on one of these virtual
> devices.
>
> So I'm guessing that it is also destroying a parent? But I can't guess
> which.. Some simple tests with veth suggest it is OK because the
> parent is virtual. But maybe bond or bridge or something?
>
> The issue in rdma is that unregistering a netdev triggers an async
> destruction of the RDMA devices. This has to be async because the
> netdev notification is delivered with RTNL held, and a rdma device
> cannot be destroyed while holding RTNL.
>
> So there is a race, I suppose, where the netdev can complete
> destruction while rdma continues, and if someone deletes the sysfs
> holding the netdev before rdma completes, I'm going to guess, that we
> hit this warning?
>
> Could it be? I would love to know what netdev the rdma device was
> created on, but it doesn't seem to show in the trace :\
>
> This theory could be made more likely by adding a sleep to
> ib_unregister_work() to increase the race window - is there some way
> to get syzkaller to search for a reproducer with that patch?


Bad it happened in kthread context. Otherwise it's usually possible to
pinpoint the test based on process name.

syz-repro utility will do reproduction process with a any kernel you give it:
https://github.com/google/syzkaller/blob/master/docs/reproducing_crashes.md

Or it's possible to run individual programs, or whole log with
syz-execprog utility:
https://github.com/google/syzkaller/blob/master/docs/executing_syzkaller_programs.md

Or maybe you could pinpoint the guilty test program by hand in the log
(it's probably somewhere closer to the end):
https://syzkaller.appspot.com/x/log.txt?x=119dd16de00000
