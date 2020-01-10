Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2DCDE136649
	for <lists+netdev@lfdr.de>; Fri, 10 Jan 2020 05:44:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731289AbgAJEns (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 9 Jan 2020 23:43:48 -0500
Received: from mail-oi1-f169.google.com ([209.85.167.169]:39788 "EHLO
        mail-oi1-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731223AbgAJEnr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 9 Jan 2020 23:43:47 -0500
Received: by mail-oi1-f169.google.com with SMTP id a67so825033oib.6
        for <netdev@vger.kernel.org>; Thu, 09 Jan 2020 20:43:46 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=G2SmWMO8U0USGh9CP+bD6AYB4pLKXvLFdmc+xDENlwo=;
        b=JC/K+F5tRxZWh8ij9Ye4+7satkF5nlKSHi0AKa4O0WYcGCIB8g1LGyY1UTFfSKweV0
         mB6WHRexc9FqWlCwugdsuTV7x3e4uQHfryio29i8S54WrgGlld8XlX4g7WnXeZlzbTey
         HYPoS/hMAGVzBsTituZNLfw9I2MkGukhziJhuHqQVpMqxtfb95R99r3GDuF++pJZf2B9
         rbXaUNzTA3mTOhJuUUKLzw7y7pAcnw93MdCIPmZHP9rkgtvZMl8Cck9jgG4UgiQUr9Ds
         7tJBr8nS7KO9WEQFY30b7aXJzqc8qhMnPdJuHzE89rwL/Aq33/FQyB/E3ALug9EYLeMs
         Z+uw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=G2SmWMO8U0USGh9CP+bD6AYB4pLKXvLFdmc+xDENlwo=;
        b=p64i0Vq/rEQc17jJZG32ROrOGwgnCKYv3bo+ff9GCgBcvt3NIX4poTo6rr2VdJCkck
         RJojeoTLE4m7UI4B9KaPGmFanqohmHqLrnWu8fdDjgqcPAJTHDLgzHYFgx7LsLYJiLmb
         DQskB71uRl+NNKeuqkfV2Fst7NVSLYKjK9VPskGQfzC1yezFohJtru4l7DxmCGXw8M+7
         M6m3UFpsq7lWYGqN+QuT+Xb4ktT9Eqv+4iNxCpRrKEFNgsxzzOIEe1z5e6sf8/dkC2En
         XDEMyXFVKYv7P5NbW/Y9hN8aBP2RMj0UT28SfhA+uNbstZLBQfy5JqbQ8DF6Dyqy+anT
         M4Pw==
X-Gm-Message-State: APjAAAXL2jQP4D0Q0C6/JPSKkh95VB1HlNCJsjy8KEjhGdy1TSpCnUqj
        FKegWT5QXYziVFLaTw9eplhLiQeSshNIwakMiWo=
X-Google-Smtp-Source: APXvYqxPArciMqoErbO7NySsP97oAGqi4P26yBJNiHuYlE6PAJeV7tQvGYqjU7oPSBLg3apIJymo74b81VcmSc711es=
X-Received: by 2002:aca:1011:: with SMTP id 17mr826729oiq.72.1578631426151;
 Thu, 09 Jan 2020 20:43:46 -0800 (PST)
MIME-Version: 1.0
References: <000000000000ab3f800598cec624@google.com> <000000000000802598059b6c7989@google.com>
 <CAM_iQpX7-BF=C+CAV3o=VeCZX7=CgdscZaazTD6QT-Tw1=XY9Q@mail.gmail.com>
 <CAMArcTXTtJB8WUuJUumP2NHVg_c19m-6EheC3JRGxzseYmHVDw@mail.gmail.com>
 <CAM_iQpVJiYHnhUJKzQpoPzaUhjrd=O4WR6zFJ+329KnWi6jJig@mail.gmail.com>
 <CAMArcTVPrKrhY63P=VgFuTQf0wUNO_9=H2R96p08-xoJ+mbZ5w@mail.gmail.com>
 <CAM_iQpX-S7cPvYTqAMkZF=avaoMi_af70dwQEiC37OoXNWA4Aw@mail.gmail.com> <CAMArcTUFK6TUYP+zwD3009m126fz+S-cAT5CN5pZ3C5axErh8g@mail.gmail.com>
In-Reply-To: <CAMArcTUFK6TUYP+zwD3009m126fz+S-cAT5CN5pZ3C5axErh8g@mail.gmail.com>
From:   Cong Wang <xiyou.wangcong@gmail.com>
Date:   Thu, 9 Jan 2020 20:43:35 -0800
Message-ID: <CAM_iQpUpZLcsC2eYPGO-UCRf047FTvP-0x8hQnDxRZ-w3vL9Tg@mail.gmail.com>
Subject: Re: WARNING: bad unlock balance in sch_direct_xmit
To:     Taehee Yoo <ap420073@gmail.com>
Cc:     syzbot <syzbot+4ec99438ed7450da6272@syzkaller.appspotmail.com>,
        Linux Kernel Network Developers <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Jan 9, 2020 at 7:06 PM Taehee Yoo <ap420073@gmail.com> wrote:
>
> On Fri, 10 Jan 2020 at 08:38, Cong Wang <xiyou.wangcong@gmail.com> wrote:
> >
> > On Wed, Jan 8, 2020 at 3:43 AM Taehee Yoo <ap420073@gmail.com> wrote:
> > >
> > > On Wed, 8 Jan 2020 at 09:34, Cong Wang <xiyou.wangcong@gmail.com> wrote:
> > > >
> > > > On Tue, Jan 7, 2020 at 3:31 AM Taehee Yoo <ap420073@gmail.com> wrote:
> > > > > After "ip link set team0 master team1", the "team1 -> team0" locking path
> > > > > will be recorded in lockdep key of both team1 and team0.
> > > > > Then, if "ip link set team1 master team0" is executed, "team0 -> team1"
> > > > > locking path also will be recorded in lockdep key. At this moment,
> > > > > lockdep will catch possible deadlock situation and it prints the above
> > > > > warning message. But, both "team0 -> team1" and "team1 -> team0"
> > > > > will not be existing concurrently. so the above message is actually wrong.
> > > > > In order to avoid this message, a recorded locking path should be
> > > > > removed. So, both lockdep_unregister_key() and lockdep_register_key()
> > > > > are needed.
> > > > >
> > > >
> > > > So, after you move the key down to each netdevice, they are now treated
> > > > as different locks. Is this stacked device scenario the reason why you
> > > > move it to per-netdevice? If so, I wonder why not just use nested locks?
> > > > Like:
> > > >
> > > > netif_addr_nested_lock(upper, 0);
> > > > netif_addr_nested_lock(lower, 1);
> > > > netif_addr_nested_unlock(lower);
> > > > netif_addr_nested_unlock(upper);
> > > >
> > > > For this case, they could still share a same key.
> > > >
> > > > Thanks for the details!
> > >
> > > Yes, the reason for using dynamic lockdep key is to avoid lockdep
> > > warning in stacked device scenario.
> > > But, the addr_list_lock case is a little bit different.
> > > There was a bug in netif_addr_lock_nested() that
> > > "dev->netdev_ops->ndo_get_lock_subclass" isn't updated after "master"
> > > and "nomaster" command.
> > > So, the wrong subclass is used, so lockdep warning message was printed.
> >
> > Hmm? I never propose netdev_ops->ndo_get_lock_subclass(), and
> > the subclasses are always 0,1, no matter which is the master device,
> > so it doesn't need a ops.
> >
>
> It's just the reason why the dynamic lockdep key was adopted instead of
> a nested lock.

Oh, but why? :) As I said, at least for the addr lock case, we can always
pass subclass in the same order as they are called if we switch it back
to static keys.

>
> >
> > > There were some ways to fix this problem, using dynamic key is just one
> > > of them. I think using the correct subclass in netif_addr_lock_nested()
> > > is also a correct way to fix that problem. Another minor reason was that
> > > the subclass is limited by 8. but dynamic key has no limitation.
> >
> > Yeah, but in practice I believe 8 is sufficient for stacked devices.
> >
>
> I agree with this.
>
> >
> > >
> > > Unfortunately, dynamic key has a problem too.
> > > lockdep limits the maximum number of lockdep keys.
> >
> >
> > Right, and also the problem reported by syzbot, that is not safe
> > during unregister and register.
> >
>
> qdisc_xmit_lock_key has this problem.
> But, I'm not sure about addr_list_lock_key.
> If addr_list_lock is used outside of RTNL, it has this problem.
> If it isn't used outside of RTNL, it doesn't have this problem.

Yeah, I am aware.


>
> > Anyway, do you think we should revert back to the static keys
> > and use subclass to address the lockdep issue instead?
> >
> > Thanks!
>
> I agree with this to reduce the number of dynamic lockdep keys.

I am trying to fix this syzbot warning, not to address the key limit.

The reason is that I think dynamic keys are not necessary and
not able to be used safely in this case. What I am still not sure
is whether using subclass (with static keys) could address the
lockdep issue you fixed with dynamic keys.

Thanks!
