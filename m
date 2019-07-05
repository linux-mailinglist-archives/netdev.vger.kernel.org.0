Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8EE63609A6
	for <lists+netdev@lfdr.de>; Fri,  5 Jul 2019 17:48:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727483AbfGEPsq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 5 Jul 2019 11:48:46 -0400
Received: from mail-io1-f67.google.com ([209.85.166.67]:36699 "EHLO
        mail-io1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726805AbfGEPsp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 5 Jul 2019 11:48:45 -0400
Received: by mail-io1-f67.google.com with SMTP id o9so4445029iom.3
        for <netdev@vger.kernel.org>; Fri, 05 Jul 2019 08:48:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=sWKzZ4l2oG1uHiftjLeI9M6SAByLvoxEawDVvdCU9es=;
        b=AW1zE9WwNnwKmaDOEDr9qUeCRGksjEeXUQRHqqqG0+h5m8JSHCZBGvL/fhGyPn4lH8
         3l0BchUgPFcCJJCyHVRc2A21adHkgoYpznNcAvbk6Lc8w/MUsw0pM8JVGy4D2uqVJ6nP
         j0kaQq2VOoScO8YW91Ug6pbAym5dZ7BUUZMkrBn2N+79WIU1QZikcZ7Xpjq6XthuZLLW
         tytvj+35IruF39L34PRJ9ZZOireaGW4paF0TOjaBe3RvK0eljsQq6vU2LvJdLCdOFRLk
         lpTWuAHaF8zn1FeZfI4ClZ2qpEcbINmqaf80OyFaSBK+/UemTL/SxoQ3sT9O3DU8lQ82
         b34w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=sWKzZ4l2oG1uHiftjLeI9M6SAByLvoxEawDVvdCU9es=;
        b=pCaHJpO5Yd4fkRu+Qz4aYXr2jBmPr1BM8WjQHgDcVjoapFdtt1cJWiHM/000BX2lxG
         o43RLGCyc87Nz1T4Zor4jklbjA2I/1hVrNk2mYhLA2ecf9H1c99Vs0eCAxglC1eEAF4J
         BXNmuUxf8LSdD8KioL4LwEYvvKaRth5xGpVoK71Xu8NTWVZkspmH16Kkv30VpPp3MUZN
         2ruBtJvCtJ+0Udeth0BIORbRn/lHQK/oG/nxhrG0CUtBPkgZZqDTbCIitDEBnK5OB0Zv
         ky2UNtgVspHYqc4lVwv1cy+QrF0uCz9SIsbXHs75WZYkOdy9dyeCB3Wf/Agrv0clSggc
         mKRA==
X-Gm-Message-State: APjAAAVq8pL07Xglj1JBK9jrBtefNbZirGPDC0VmyzgO3qdgmmPHEnuV
        cDhYyqEOhSuJkLDbnepZFvLHeT0mLUh0LGaMlPJ6Bw==
X-Google-Smtp-Source: APXvYqxteQikD8RDI1mrbsJR81IJ6iSofkhpqOpCfA+Cd25ZxQxbLnqofMOnU4//vy4Z5+IH5UESTz2vlc8kWQhrhIs=
X-Received: by 2002:a5d:80d6:: with SMTP id h22mr4931637ior.231.1562341724560;
 Fri, 05 Jul 2019 08:48:44 -0700 (PDT)
MIME-Version: 1.0
References: <000000000000d3f34b058c3d5a4f@google.com> <20190626184251.GE3116@mit.edu>
 <20190626210351.GF3116@mit.edu> <20190626224709.GH3116@mit.edu>
 <CACT4Y+YTpUErjEmjrqki-tJ0Lyx0c53MQDGVS4CixfmcAnuY=A@mail.gmail.com> <20190705151658.GP26519@linux.ibm.com>
In-Reply-To: <20190705151658.GP26519@linux.ibm.com>
From:   Dmitry Vyukov <dvyukov@google.com>
Date:   Fri, 5 Jul 2019 17:48:31 +0200
Message-ID: <CACT4Y+aNLHrYj1pYbkXO7CKESLeB-5enkSDK7ksgkMA3KtwJ+w@mail.gmail.com>
Subject: Re: INFO: rcu detected stall in ext4_write_checks
To:     "Paul E. McKenney" <paulmck@linux.ibm.com>
Cc:     "Theodore Ts'o" <tytso@mit.edu>,
        syzbot <syzbot+4bfbbf28a2e50ab07368@syzkaller.appspotmail.com>,
        Andreas Dilger <adilger.kernel@dilger.ca>,
        David Miller <davem@davemloft.net>, eladr@mellanox.com,
        Ido Schimmel <idosch@mellanox.com>,
        Jiri Pirko <jiri@mellanox.com>,
        John Stultz <john.stultz@linaro.org>,
        linux-ext4@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
        netdev <netdev@vger.kernel.org>,
        syzkaller-bugs <syzkaller-bugs@googlegroups.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Peter Zijlstra <peterz@infradead.org>,
        Ingo Molnar <mingo@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Jul 5, 2019 at 5:17 PM Paul E. McKenney <paulmck@linux.ibm.com> wrote:
>
> On Fri, Jul 05, 2019 at 03:24:26PM +0200, Dmitry Vyukov wrote:
> > On Thu, Jun 27, 2019 at 12:47 AM Theodore Ts'o <tytso@mit.edu> wrote:
> > >
> > > More details about what is going on.  First, it requires root, because
> > > one of that is required is using sched_setattr (which is enough to
> > > shoot yourself in the foot):
> > >
> > > sched_setattr(0, {size=0, sched_policy=0x6 /* SCHED_??? */, sched_flags=0, sched_nice=0, sched_priority=0, sched_runtime=2251799813724439, sched_deadline=4611686018427453437, sched_period=0}, 0) = 0
> > >
> > > This is setting the scheduler policy to be SCHED_DEADLINE, with a
> > > runtime parameter of 2251799.813724439 seconds (or 26 days) and a
> > > deadline of 4611686018.427453437 seconds (or 146 *years*).  This means
> > > a particular kernel thread can run for up to 26 **days** before it is
> > > scheduled away, and if a kernel reads gets woken up or sent a signal,
> > > no worries, it will wake up roughly seven times the interval that Rip
> > > Van Winkle spent snoozing in a cave in the Catskill Mountains (in
> > > Washington Irving's short story).
> > >
> > > We then kick off a half-dozen threads all running:
> > >
> > >    sendfile(fd, fd, &pos, 0x8080fffffffe);
> > >
> > > (and since count is a ridiculously large number, this gets cut down to):
> > >
> > >    sendfile(fd, fd, &pos, 2147479552);
> > >
> > > Is it any wonder that we are seeing RCU stalls?   :-)
> >
> > +Peter, Ingo for sched_setattr and +Paul for rcu
> >
> > First of all: is it a semi-intended result of a root (CAP_SYS_NICE)
> > doing local DoS abusing sched_setattr? It would perfectly reasonable
> > to starve other processes, but I am not sure about rcu. In the end the
> > high prio process can use rcu itself, and then it will simply blow
> > system memory by stalling rcu. So it seems that rcu stalls should not
> > happen as a result of weird sched_setattr values. If that is the case,
> > what needs to be fixed? sched_setattr? rcu? sendfile?
>
> Does the (untested, probably does not even build) patch shown below help?
> This patch assumes that the kernel was built with CONFIG_PREEMPT=n.
> And that I found all the tight loops on the do_sendfile() code path.

The config used when this happened is referenced from here:
https://syzkaller.appspot.com/bug?extid=4bfbbf28a2e50ab07368
and it contains:
CONFIG_PREEMPT=y

So... what does this mean? The loop should have been preempted without
the cond_resched() then, right?

> > If this is semi-intended, the only option I see is to disable
> > something in syzkaller: sched_setattr entirely, or drop CAP_SYS_NICE,
> > or ...? Any preference either way?
>
> Long-running tight loops in the kernel really should contain
> cond_resched() or better.
>
>                                                         Thanx, Paul
>
> ------------------------------------------------------------------------
>
> diff --git a/fs/splice.c b/fs/splice.c
> index 25212dcca2df..50aa3286764a 100644
> --- a/fs/splice.c
> +++ b/fs/splice.c
> @@ -985,6 +985,7 @@ ssize_t splice_direct_to_actor(struct file *in, struct splice_desc *sd,
>                         sd->pos = prev_pos + ret;
>                         goto out_release;
>                 }
> +               cond_resched();
>         }
>
>  done:
>
