Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3B8B513670A
	for <lists+netdev@lfdr.de>; Fri, 10 Jan 2020 07:02:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726682AbgAJGCb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 10 Jan 2020 01:02:31 -0500
Received: from mail-lj1-f193.google.com ([209.85.208.193]:43954 "EHLO
        mail-lj1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726273AbgAJGCb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 10 Jan 2020 01:02:31 -0500
Received: by mail-lj1-f193.google.com with SMTP id a13so842169ljm.10
        for <netdev@vger.kernel.org>; Thu, 09 Jan 2020 22:02:29 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=xZ52Phhm57j0Y3PAFJEeLJ6Pi8zjGYI2SlCRDaatLPI=;
        b=SQsTbEUjQWuYfQdWAZmQAphygExERw8JKPk8RJbIZ8lDl/Lo64HnzERVYclAPkQ2oG
         DY9P5n5Rs+Tbt/6FvKbi76jge2WDz4pBnCFLNkQeBXqokfZfBdGboA0YXTSX10b/NdEU
         KhSApzscqueGYZHMEMy1hIUHn7KOOwXUcwPWk9nheQs4gKXqrufiTNdKNO/Abcs+utHl
         AevC1r+uFuIrDIHMUuY2L8/qNTSciUVzzT0FreLBiGkKoM2g72+wGrMhOHqCnyEX7FAu
         VxlmCBYyhtqxVQ/hOiRfNFcu9Xg/acz1VaFhOC1sLTzpQRrGqbsj9BOAiJBG+9NRqUmx
         z0Pg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=xZ52Phhm57j0Y3PAFJEeLJ6Pi8zjGYI2SlCRDaatLPI=;
        b=NoVqQcRrqm9K/CfD/buD03Soh2Rx7x+VaKS6Sf5YgNI9wkiFh7dWYHBCcfi1Hq8Beq
         aHdVE624PDWMc4kRrx+zbIozkFCXE0/DO4h4XQTbntqA+abkXjgaIAcXkcWpHwSm8bhe
         9B4w9SkOmSrAAlyDzhoXZtAKD+byW0W0y7SJDDCyWR+3at+GQqm49v2qCxstN2uouOTR
         sTgP8FsIKcsZchJPIX9+UJwbiEsvGjhw5kE/heAAXV0blXgLaqAFYgcsoW9E1w3XTxYw
         ykXyf5fZDVZJoKPz4cK/HS3A+hIEa5v8BPGm8xDQzztTGp3tc49/M+6baurN9hUBhVRi
         M+Dg==
X-Gm-Message-State: APjAAAUSafEhsEdM8KdNdC0geaeexKGy3xWG+ZdxF7zGmWRU+hJKcaPR
        /pB1n7pRDSbI5DMliGP+MM0NaiqLtPaLTzYs9w1Qwx4u
X-Google-Smtp-Source: APXvYqzSrNJjlAwpZQ3EJ7LbU5BGPQEMiRXtiZYAk1VFrNi6qOD7T/DonNTj94QeauXtvD0qIC/UC7/7/4j9fbxK7bE=
X-Received: by 2002:a2e:88c5:: with SMTP id a5mr1340341ljk.201.1578636148481;
 Thu, 09 Jan 2020 22:02:28 -0800 (PST)
MIME-Version: 1.0
References: <000000000000ab3f800598cec624@google.com> <000000000000802598059b6c7989@google.com>
 <CAM_iQpX7-BF=C+CAV3o=VeCZX7=CgdscZaazTD6QT-Tw1=XY9Q@mail.gmail.com>
 <CAMArcTXTtJB8WUuJUumP2NHVg_c19m-6EheC3JRGxzseYmHVDw@mail.gmail.com>
 <CAM_iQpVJiYHnhUJKzQpoPzaUhjrd=O4WR6zFJ+329KnWi6jJig@mail.gmail.com>
 <CAMArcTVPrKrhY63P=VgFuTQf0wUNO_9=H2R96p08-xoJ+mbZ5w@mail.gmail.com>
 <CAM_iQpX-S7cPvYTqAMkZF=avaoMi_af70dwQEiC37OoXNWA4Aw@mail.gmail.com>
 <CAMArcTUFK6TUYP+zwD3009m126fz+S-cAT5CN5pZ3C5axErh8g@mail.gmail.com> <CAM_iQpUpZLcsC2eYPGO-UCRf047FTvP-0x8hQnDxRZ-w3vL9Tg@mail.gmail.com>
In-Reply-To: <CAM_iQpUpZLcsC2eYPGO-UCRf047FTvP-0x8hQnDxRZ-w3vL9Tg@mail.gmail.com>
From:   Taehee Yoo <ap420073@gmail.com>
Date:   Fri, 10 Jan 2020 15:02:16 +0900
Message-ID: <CAMArcTV66StxE=Pjiv6zsh0san039tuVvsKNE2Sb=7+jJ3xEdQ@mail.gmail.com>
Subject: Re: WARNING: bad unlock balance in sch_direct_xmit
To:     Cong Wang <xiyou.wangcong@gmail.com>
Cc:     syzbot <syzbot+4ec99438ed7450da6272@syzkaller.appspotmail.com>,
        Linux Kernel Network Developers <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 10 Jan 2020 at 13:43, Cong Wang <xiyou.wangcong@gmail.com> wrote:
>
> On Thu, Jan 9, 2020 at 7:06 PM Taehee Yoo <ap420073@gmail.com> wrote:
> >
> > On Fri, 10 Jan 2020 at 08:38, Cong Wang <xiyou.wangcong@gmail.com> wrote:
> > >
> > > On Wed, Jan 8, 2020 at 3:43 AM Taehee Yoo <ap420073@gmail.com> wrote:
> > > >
> > > > On Wed, 8 Jan 2020 at 09:34, Cong Wang <xiyou.wangcong@gmail.com> wrote:
> > > > >
> > > > > On Tue, Jan 7, 2020 at 3:31 AM Taehee Yoo <ap420073@gmail.com> wrote:
> > > > > > After "ip link set team0 master team1", the "team1 -> team0" locking path
> > > > > > will be recorded in lockdep key of both team1 and team0.
> > > > > > Then, if "ip link set team1 master team0" is executed, "team0 -> team1"
> > > > > > locking path also will be recorded in lockdep key. At this moment,
> > > > > > lockdep will catch possible deadlock situation and it prints the above
> > > > > > warning message. But, both "team0 -> team1" and "team1 -> team0"
> > > > > > will not be existing concurrently. so the above message is actually wrong.
> > > > > > In order to avoid this message, a recorded locking path should be
> > > > > > removed. So, both lockdep_unregister_key() and lockdep_register_key()
> > > > > > are needed.
> > > > > >
> > > > >
> > > > > So, after you move the key down to each netdevice, they are now treated
> > > > > as different locks. Is this stacked device scenario the reason why you
> > > > > move it to per-netdevice? If so, I wonder why not just use nested locks?
> > > > > Like:
> > > > >
> > > > > netif_addr_nested_lock(upper, 0);
> > > > > netif_addr_nested_lock(lower, 1);
> > > > > netif_addr_nested_unlock(lower);
> > > > > netif_addr_nested_unlock(upper);
> > > > >
> > > > > For this case, they could still share a same key.
> > > > >
> > > > > Thanks for the details!
> > > >
> > > > Yes, the reason for using dynamic lockdep key is to avoid lockdep
> > > > warning in stacked device scenario.
> > > > But, the addr_list_lock case is a little bit different.
> > > > There was a bug in netif_addr_lock_nested() that
> > > > "dev->netdev_ops->ndo_get_lock_subclass" isn't updated after "master"
> > > > and "nomaster" command.
> > > > So, the wrong subclass is used, so lockdep warning message was printed.
> > >
> > > Hmm? I never propose netdev_ops->ndo_get_lock_subclass(), and
> > > the subclasses are always 0,1, no matter which is the master device,
> > > so it doesn't need a ops.
> > >
> >
> > It's just the reason why the dynamic lockdep key was adopted instead of
> > a nested lock.
>
> Oh, but why? :) As I said, at least for the addr lock case, we can always
> pass subclass in the same order as they are called if we switch it back
> to static keys.
>

ndo_get_lock_subclass() was used to calculate subclass which was used by
netif_addr_lock_nested().

-static inline void netif_addr_lock_nested(struct net_device *dev)
-{
-       int subclass = SINGLE_DEPTH_NESTING;
-
-       if (dev->netdev_ops->ndo_get_lock_subclass)
-               subclass = dev->netdev_ops->ndo_get_lock_subclass(dev);
-
-       spin_lock_nested(&dev->addr_list_lock, subclass);
-}

The most important thing about nested lock is to get the correct subclass.
nest_level was used as subclass and this was calculated by
->ndo_get_lock_subclass().
But, ->ndo_get_lock_subclass() didn't calculate correct subclass.
After "master" and "nomaster" operations, nest_level should be updated
recursively, but it didn't. So incorrect subclass was used.

team3 <-- subclass 0

"ip link set team3 master team2"

team2 <-- subclass 0
team3 <-- subclass 1

"ip link set team2 master team1"

team1 <-- subclass 0
team3 <-- subclass 1
team3 <-- subclass 1

"ip link set team1 master team0"

team0 <-- subclass 0
team1 <-- subclass 1
team3 <-- subclass 1
team3 <-- subclass 1

After "master" and "nomaster" operation, subclass values of all lower or
upper interfaces would be changed. But ->ndo_get_lock_subclass()
didn't update subclass recursively, lockdep warning appeared.
In order to fix this, I had two ways.
1. use dynamic keys instead of static keys.
2. fix ndo_get_lock_subclass().

The reason why I adopted using dynamic keys instead of fixing
->ndo_get_lock_subclass() is that the ->ndo_get_lock_subclass() isn't
a common helper function.
So, driver writers should implement ->ndo_get_lock_subclass().
If we use dynamic keys, ->ndo_get_lock_subclass() code could be removed.

> >
> > >
> > > > There were some ways to fix this problem, using dynamic key is just one
> > > > of them. I think using the correct subclass in netif_addr_lock_nested()
> > > > is also a correct way to fix that problem. Another minor reason was that
> > > > the subclass is limited by 8. but dynamic key has no limitation.
> > >
> > > Yeah, but in practice I believe 8 is sufficient for stacked devices.
> > >
> >
> > I agree with this.
> >
> > >
> > > >
> > > > Unfortunately, dynamic key has a problem too.
> > > > lockdep limits the maximum number of lockdep keys.
> > >
> > >
> > > Right, and also the problem reported by syzbot, that is not safe
> > > during unregister and register.
> > >
> >
> > qdisc_xmit_lock_key has this problem.
> > But, I'm not sure about addr_list_lock_key.
> > If addr_list_lock is used outside of RTNL, it has this problem.
> > If it isn't used outside of RTNL, it doesn't have this problem.
>
> Yeah, I am aware.
>
>
> >
> > > Anyway, do you think we should revert back to the static keys
> > > and use subclass to address the lockdep issue instead?
> > >
> > > Thanks!
> >
> > I agree with this to reduce the number of dynamic lockdep keys.
>
> I am trying to fix this syzbot warning, not to address the key limit.
>
> The reason is that I think dynamic keys are not necessary and
> not able to be used safely in this case. What I am still not sure
> is whether using subclass (with static keys) could address the
> lockdep issue you fixed with dynamic keys.
>
> Thanks!

What I fixed problems with dynamic lockdep keys could be fixed by
nested lock too. I think if the subclass value synchronization routine
works well, there will be no problem.

Thanks a lot!
