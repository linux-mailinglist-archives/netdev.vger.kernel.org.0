Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9641E138EC0
	for <lists+netdev@lfdr.de>; Mon, 13 Jan 2020 11:14:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728904AbgAMKOB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 13 Jan 2020 05:14:01 -0500
Received: from mail-lj1-f181.google.com ([209.85.208.181]:39463 "EHLO
        mail-lj1-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726133AbgAMKN5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 13 Jan 2020 05:13:57 -0500
Received: by mail-lj1-f181.google.com with SMTP id l2so9330473lja.6
        for <netdev@vger.kernel.org>; Mon, 13 Jan 2020 02:13:56 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=hZJxZMQS594195Qe6tKoE26QmSPdp9R0kh3oLsErtOg=;
        b=qthhyP3Bk8MI8oRNnwDxAO9lpEjEQSIckE3uSZXWOkNnqmO/xRLee1CCKvb20j3+eZ
         CxSYIteDBBX0nSWvcS4Z915ANVUQjMWmCn4rFhhhGonPztvTPO2s8busGHqDadigNDCA
         P/rQHPfg1FDV2jS/bXHVr/XogXxV1xiibaN4T7VGrLkbL/hoUhtMUOHzQUbRGPjHBoUI
         o0tlWTo6SV+8vva94Ht1G4OhdkFZ7+jwxt311DlJkRtR4k8LX+NsLiSZLa72xBFasHTg
         b8/TInhc2tBK3tgBE4FZSSFUu5tPcHOIrxwNmlJE/kwiAdtf3yTMEN3hHLT/srRmprlo
         bzfg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=hZJxZMQS594195Qe6tKoE26QmSPdp9R0kh3oLsErtOg=;
        b=q7Jb89ZuOrfDgs/DC09LQ4hqjgiqA5cGjFU/1hcYv89dBny0/hXNL+C88IvPVrX71+
         AKi81cKUjNgQADnGyiHmOmj3WBbo7kLAwm8VVGrwyxk6QdtgwucClUYm+L2N9qPBqjVa
         8Ghl0xLeRnzGhd5VS74xyuZVRU/T1KWpHjgrTuLwJW6WW5XkCe/imVkfPF+T+wrr9w2o
         M2r4AsstL+HWd1vnNuB3Q/dF50NG5COHxm5xvbqM89vZasRkIXA6zWc7XeEH30YcOPgc
         4LhTUyVYLoWHuSLLMmuKNf1lcUXAk906BzNPeETAYZQqv84Y9sxQsabZtO5xL5Tmus8I
         TNzQ==
X-Gm-Message-State: APjAAAVDJNIJifwrZcOj/ci0V+98zjeGCVL1vXPRbirC2ceEaYp2/3/J
        vd9bwFSzKNcuoXafKAySI18NUPxXWtBBQgK5K7M=
X-Google-Smtp-Source: APXvYqwPdvpwzOsCN499JBKvI5ZRMkCYxRh7TEsFaw32YbwIZtXW4GXRGPls2IvF+/pCqI8IHzPxKxS5lkqWZZ0bDKE=
X-Received: by 2002:a2e:880a:: with SMTP id x10mr10112502ljh.211.1578910435363;
 Mon, 13 Jan 2020 02:13:55 -0800 (PST)
MIME-Version: 1.0
References: <000000000000ab3f800598cec624@google.com> <000000000000802598059b6c7989@google.com>
 <CAM_iQpX7-BF=C+CAV3o=VeCZX7=CgdscZaazTD6QT-Tw1=XY9Q@mail.gmail.com>
 <CAMArcTXTtJB8WUuJUumP2NHVg_c19m-6EheC3JRGxzseYmHVDw@mail.gmail.com>
 <CAM_iQpVJiYHnhUJKzQpoPzaUhjrd=O4WR6zFJ+329KnWi6jJig@mail.gmail.com>
 <CAMArcTVPrKrhY63P=VgFuTQf0wUNO_9=H2R96p08-xoJ+mbZ5w@mail.gmail.com>
 <CAM_iQpX-S7cPvYTqAMkZF=avaoMi_af70dwQEiC37OoXNWA4Aw@mail.gmail.com>
 <CAMArcTUFK6TUYP+zwD3009m126fz+S-cAT5CN5pZ3C5axErh8g@mail.gmail.com>
 <CAM_iQpUpZLcsC2eYPGO-UCRf047FTvP-0x8hQnDxRZ-w3vL9Tg@mail.gmail.com>
 <CAMArcTV66StxE=Pjiv6zsh0san039tuVvsKNE2Sb=7+jJ3xEdQ@mail.gmail.com> <CAM_iQpU9EXx7xWAaps2E3DWiZbt25ByCK4sR=njYMHF=KsvLFg@mail.gmail.com>
In-Reply-To: <CAM_iQpU9EXx7xWAaps2E3DWiZbt25ByCK4sR=njYMHF=KsvLFg@mail.gmail.com>
From:   Taehee Yoo <ap420073@gmail.com>
Date:   Mon, 13 Jan 2020 19:13:43 +0900
Message-ID: <CAMArcTVy1vf38ktQY4e_V7ZnCq+pDf49jFHYGnZHSEy1zjinkg@mail.gmail.com>
Subject: Re: WARNING: bad unlock balance in sch_direct_xmit
To:     Cong Wang <xiyou.wangcong@gmail.com>
Cc:     syzbot <syzbot+4ec99438ed7450da6272@syzkaller.appspotmail.com>,
        Linux Kernel Network Developers <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, 12 Jan 2020 at 06:53, Cong Wang <xiyou.wangcong@gmail.com> wrote:
>
> On Thu, Jan 9, 2020 at 10:02 PM Taehee Yoo <ap420073@gmail.com> wrote:
> > ndo_get_lock_subclass() was used to calculate subclass which was used by
> > netif_addr_lock_nested().
> >
> > -static inline void netif_addr_lock_nested(struct net_device *dev)
> > -{
> > -       int subclass = SINGLE_DEPTH_NESTING;
> > -
> > -       if (dev->netdev_ops->ndo_get_lock_subclass)
> > -               subclass = dev->netdev_ops->ndo_get_lock_subclass(dev);
> > -
> > -       spin_lock_nested(&dev->addr_list_lock, subclass);
> > -}
> >
> > The most important thing about nested lock is to get the correct subclass.
> > nest_level was used as subclass and this was calculated by
> > ->ndo_get_lock_subclass().
> > But, ->ndo_get_lock_subclass() didn't calculate correct subclass.
> > After "master" and "nomaster" operations, nest_level should be updated
> > recursively, but it didn't. So incorrect subclass was used.
> >
> > team3 <-- subclass 0
> >
> > "ip link set team3 master team2"
> >
> > team2 <-- subclass 0
> > team3 <-- subclass 1
> >
> > "ip link set team2 master team1"
> >
> > team1 <-- subclass 0
> > team3 <-- subclass 1
> > team3 <-- subclass 1
> >
> > "ip link set team1 master team0"
> >
> > team0 <-- subclass 0
> > team1 <-- subclass 1
> > team3 <-- subclass 1
> > team3 <-- subclass 1
> >
> > After "master" and "nomaster" operation, subclass values of all lower or
> > upper interfaces would be changed. But ->ndo_get_lock_subclass()
> > didn't update subclass recursively, lockdep warning appeared.
> > In order to fix this, I had two ways.
> > 1. use dynamic keys instead of static keys.
> > 2. fix ndo_get_lock_subclass().
> >
> > The reason why I adopted using dynamic keys instead of fixing
> > ->ndo_get_lock_subclass() is that the ->ndo_get_lock_subclass() isn't
> > a common helper function.
> > So, driver writers should implement ->ndo_get_lock_subclass().
> > If we use dynamic keys, ->ndo_get_lock_subclass() code could be removed.
> >
>
> The details you provide here are really helpful for me to understand
> the reasons behind your changes. Let me think about this and see how
> I could address both problems. This appears to be harder than I originally
> thought.
>
> >
> > What I fixed problems with dynamic lockdep keys could be fixed by
> > nested lock too. I think if the subclass value synchronization routine
> > works well, there will be no problem.
>
> Great! We are on the same page.
>
> Thanks for all the information and the reproducer too!

I really glad my explanation helps you!

Thank you so much!
