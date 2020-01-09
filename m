Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 693BA1363EB
	for <lists+netdev@lfdr.de>; Fri, 10 Jan 2020 00:38:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729321AbgAIXiM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 9 Jan 2020 18:38:12 -0500
Received: from mail-oi1-f196.google.com ([209.85.167.196]:40058 "EHLO
        mail-oi1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726380AbgAIXiM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 9 Jan 2020 18:38:12 -0500
Received: by mail-oi1-f196.google.com with SMTP id c77so313405oib.7
        for <netdev@vger.kernel.org>; Thu, 09 Jan 2020 15:38:11 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=ci1bcUmfYk+C4J64YbtnO0L55bSq6ltogHHLujPtbFE=;
        b=l4nJj5O+WE3iJwmX8EISiug8ILVB+CCaA31rn+hP4tnukBEjb+8qKX6ohFM+sLUiI1
         wMa/3dQNvmal9Et0W08LOZ/T4sQX6Wpx05UXzb5ybqo9lEmR/SBSSkCKbpYzJoRTXSZY
         Y3GLZMaecFqKhzYw8uW9pbHlidA1q6U5/xwfElCRv/c2xa23JrAeOmUJiqZi3rmeCDde
         yPiYD3YeCmD6niinC4ONFogKXSwrccQE5SQe0nuPsjh6RTM4TGlnHRFAvevC8uqDgN8p
         8v4IYEWiHV8bWKut+rnpSZRqpryEkQSYZdJpL7U5PLhIkQyRf/CbwLS5PAYCdEDOyaYW
         FvKA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=ci1bcUmfYk+C4J64YbtnO0L55bSq6ltogHHLujPtbFE=;
        b=tzGW9DnySusNzzzO1hTaG9r7b+/7ODYCtP9H3A9q5spSY/SJ7QI6nFENjZVjGcSHeV
         O4Ro0IIuAANeF94Ge/5ewqXf6qNsdVDvDWXF6uq0Uvs/0tn9+qkyG7+GLwVbqxg4ntL9
         kkRW79fNcoIjW888fUlTnCQ2Z6nICpeAdCz6lUo0tjoUdwnH4XED4i2PCtCRytjaqm3Z
         E5vLQfoi29Qm0dHDeKGU1O1vs2ltwaAS27ASeT/+gud4GfltM1MYfwssQ6dY++CFK8Oi
         LX/qUDbxWOctcRIrhz+91WSasdskjrpL3wi8bqzqxb1sukSfPEKyw+WzViPzm2LfAZY6
         zbWQ==
X-Gm-Message-State: APjAAAXVCrwFrMyW7gdIuhuUEWc9Aawutnj1cuLKBGbrD8ZSV/rBO6iO
        hGUMDC2dAftc6z2dYX/MnzstEcf3ELNH1m+vh04=
X-Google-Smtp-Source: APXvYqwiT8zaHtyuYwCWsVhLkIdeiAVkn6yvNIyEmhSjz+K5bnWp0jTCbNADW8yOH1ecTJOOLn/613RUvrzHjM0lPMY=
X-Received: by 2002:aca:6545:: with SMTP id j5mr4317oiw.60.1578613091477; Thu,
 09 Jan 2020 15:38:11 -0800 (PST)
MIME-Version: 1.0
References: <000000000000ab3f800598cec624@google.com> <000000000000802598059b6c7989@google.com>
 <CAM_iQpX7-BF=C+CAV3o=VeCZX7=CgdscZaazTD6QT-Tw1=XY9Q@mail.gmail.com>
 <CAMArcTXTtJB8WUuJUumP2NHVg_c19m-6EheC3JRGxzseYmHVDw@mail.gmail.com>
 <CAM_iQpVJiYHnhUJKzQpoPzaUhjrd=O4WR6zFJ+329KnWi6jJig@mail.gmail.com> <CAMArcTVPrKrhY63P=VgFuTQf0wUNO_9=H2R96p08-xoJ+mbZ5w@mail.gmail.com>
In-Reply-To: <CAMArcTVPrKrhY63P=VgFuTQf0wUNO_9=H2R96p08-xoJ+mbZ5w@mail.gmail.com>
From:   Cong Wang <xiyou.wangcong@gmail.com>
Date:   Thu, 9 Jan 2020 15:38:00 -0800
Message-ID: <CAM_iQpX-S7cPvYTqAMkZF=avaoMi_af70dwQEiC37OoXNWA4Aw@mail.gmail.com>
Subject: Re: WARNING: bad unlock balance in sch_direct_xmit
To:     Taehee Yoo <ap420073@gmail.com>
Cc:     syzbot <syzbot+4ec99438ed7450da6272@syzkaller.appspotmail.com>,
        Linux Kernel Network Developers <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jan 8, 2020 at 3:43 AM Taehee Yoo <ap420073@gmail.com> wrote:
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

Hmm? I never propose netdev_ops->ndo_get_lock_subclass(), and
the subclasses are always 0,1, no matter which is the master device,
so it doesn't need a ops.


> There were some ways to fix this problem, using dynamic key is just one
> of them. I think using the correct subclass in netif_addr_lock_nested()
> is also a correct way to fix that problem. Another minor reason was that
> the subclass is limited by 8. but dynamic key has no limitation.

Yeah, but in practice I believe 8 is sufficient for stacked devices.


>
> Unfortunately, dynamic key has a problem too.
> lockdep limits the maximum number of lockdep keys.


Right, and also the problem reported by syzbot, that is not safe
during unregister and register.

Anyway, do you think we should revert back to the static keys
and use subclass to address the lockdep issue instead?

Thanks!
