Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 95F3D138FC8
	for <lists+netdev@lfdr.de>; Mon, 13 Jan 2020 12:08:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728346AbgAMLIp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 13 Jan 2020 06:08:45 -0500
Received: from mail-qk1-f172.google.com ([209.85.222.172]:46564 "EHLO
        mail-qk1-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726193AbgAMLIp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 13 Jan 2020 06:08:45 -0500
Received: by mail-qk1-f172.google.com with SMTP id r14so8014377qke.13
        for <netdev@vger.kernel.org>; Mon, 13 Jan 2020 03:08:45 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=NDxnmPtvSGzzeJPZGyzWDMJa+QjPbLIfskiiXnAiIGs=;
        b=eTFXZeYgGWhe2RqqUNxARLPN+yF0DiEVMA2vKrnbyyWGrAcjRhN6qF6PzPn99UQiYR
         GBDR1OWZmXIKSESj8ybF48OryL8SC6OBIM2sqpUsudCfjZljTi0Klwxva5Vr8q2jFwrr
         eI/fEGPgqEg0UAIMaj6uj+o2GGB7AHlhw+S9s8WtVhUGA+6oMYVkBiIdJhUnLAeXzy6j
         Id38VqtHzemA9pczMMoqQDe5r10gWgy7DlqkhabfHRt/V+FdO4KDo7ww/audpTiU04hU
         t2No5haP+AyMs0X7b1me8Wj7HGEZ+CpYhJ0dWU7kZnb4KPixJ+dA6H3bgoojsGwI6DLq
         ADVQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=NDxnmPtvSGzzeJPZGyzWDMJa+QjPbLIfskiiXnAiIGs=;
        b=SD3y/UG22Xm5vSGKcJxgOMT5Ov/RSNvB+6N/zoCYk07BjZk//VsPh+huH9tb7LMCfQ
         3UntDvwdDbVYQ/Zq7JUW1ogBos1I5RB39aKItryRQQ3CJRUY6jOrcP8NKsYncj34V26N
         /gfpZfu1gs9T6rolnyAJ8ypWfvxmLSkryK4m+uNj4YZpRmDxEVcbMlRRhkeRsavAwf1j
         hRF+lkZl09u48xKMJko4JCtPHmBgpgybKZvLyrnE0Fdu/sgAUDKgAFHA8LabwJunrXQq
         Pc/PIuDJsHQUvfyIrWlhbgPGxOLYWGvHCKMjXSzbklWzi9RlT/11t8ouR8+NPp7VCKIe
         P9lQ==
X-Gm-Message-State: APjAAAVKD1rRzDB4rIEOecI83m7RC0CyfZ3c15NZYYt2nZtdqmxEfEON
        0lXvgkUmmP/au1DRvDqIPImWmXOUofIi114LVN2H7A==
X-Google-Smtp-Source: APXvYqxQGyK0Ge5+xgutPLUgyR8mWRfPeinvZ/SDIQ3SSfvBNmdYHEs5esk+m8/e7q0c9hibP8HP6lhrkVV/BeqvDTQ=
X-Received: by 2002:a37:e312:: with SMTP id y18mr15828723qki.250.1578913724420;
 Mon, 13 Jan 2020 03:08:44 -0800 (PST)
MIME-Version: 1.0
References: <000000000000ab3f800598cec624@google.com> <000000000000802598059b6c7989@google.com>
 <CAM_iQpX7-BF=C+CAV3o=VeCZX7=CgdscZaazTD6QT-Tw1=XY9Q@mail.gmail.com>
 <CAMArcTXTtJB8WUuJUumP2NHVg_c19m-6EheC3JRGxzseYmHVDw@mail.gmail.com>
 <CAM_iQpVJiYHnhUJKzQpoPzaUhjrd=O4WR6zFJ+329KnWi6jJig@mail.gmail.com> <CAMArcTVPrKrhY63P=VgFuTQf0wUNO_9=H2R96p08-xoJ+mbZ5w@mail.gmail.com>
In-Reply-To: <CAMArcTVPrKrhY63P=VgFuTQf0wUNO_9=H2R96p08-xoJ+mbZ5w@mail.gmail.com>
From:   Dmitry Vyukov <dvyukov@google.com>
Date:   Mon, 13 Jan 2020 12:08:32 +0100
Message-ID: <CACT4Y+ZcTRhfoLs-9Va1p1fZFDsCxd8gjaxUGgEPqgtjBvjWzQ@mail.gmail.com>
Subject: Re: WARNING: bad unlock balance in sch_direct_xmit
To:     Taehee Yoo <ap420073@gmail.com>
Cc:     Cong Wang <xiyou.wangcong@gmail.com>,
        syzbot <syzbot+4ec99438ed7450da6272@syzkaller.appspotmail.com>,
        Linux Kernel Network Developers <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jan 8, 2020 at 12:44 PM Taehee Yoo <ap420073@gmail.com> wrote:
>
> On Wed, 8 Jan 2020 at 09:34, Cong Wang <xiyou.wangcong@gmail.com> wrote:
> >
> > On Tue, Jan 7, 2020 at 3:31 AM Taehee Yoo <ap420073@gmail.com> wrote:
> > > After "ip link set team0 master team1", the "team1 -> team0" locking path
> > > will be recorded in lockdep key of both team1 and team0.
> > > Then, if "ip link set team1 master team0" is executed, "team0 -> team1"
> > > locking path also will be recorded in lockdep key. At this moment,
> > > lockdep will catch possible deadlock situation and it prints the above
> > > warning message. But, both "team0 -> team1" and "team1 -> team0"
> > > will not be existing concurrently. so the above message is actually wrong.
> > > In order to avoid this message, a recorded locking path should be
> > > removed. So, both lockdep_unregister_key() and lockdep_register_key()
> > > are needed.
> > >
> >
> > So, after you move the key down to each netdevice, they are now treated
> > as different locks. Is this stacked device scenario the reason why you
> > move it to per-netdevice? If so, I wonder why not just use nested locks?
> > Like:
> >
> > netif_addr_nested_lock(upper, 0);
> > netif_addr_nested_lock(lower, 1);
> > netif_addr_nested_unlock(lower);
> > netif_addr_nested_unlock(upper);
> >
> > For this case, they could still share a same key.
> >
> > Thanks for the details!
>
> Yes, the reason for using dynamic lockdep key is to avoid lockdep
> warning in stacked device scenario.
> But, the addr_list_lock case is a little bit different.
> There was a bug in netif_addr_lock_nested() that
> "dev->netdev_ops->ndo_get_lock_subclass" isn't updated after "master"
> and "nomaster" command.
> So, the wrong subclass is used, so lockdep warning message was printed.
> There were some ways to fix this problem, using dynamic key is just one
> of them. I think using the correct subclass in netif_addr_lock_nested()
> is also a correct way to fix that problem. Another minor reason was that
> the subclass is limited by 8. but dynamic key has no limitation.
>
> Unfortunately, dynamic key has a problem too.
> lockdep limits the maximum number of lockdep keys.
>    $cat /proc/lockdep_stats
>    lock-classes:                         1228 [max: 8192]
>
> So, If so many network interfaces are created, they use so many
> lockdep keys. If so, lockdep will stop.
> This is the cause of "BUG: MAX_LOCKDEP_KEYS too low!".

Hi Taehee, Cong,

We actually have some serious problems with lockdep limits recently:
https://groups.google.com/g/syzkaller-bugs/c/O9pFzd9KABU/m/KCuRo3w5CgAJ
I wonder if it's related to what you mentioned... I will CC you on
that other thread.
