Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 885BF3FCCD5
	for <lists+netdev@lfdr.de>; Tue, 31 Aug 2021 20:17:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236670AbhHaSRx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 31 Aug 2021 14:17:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34220 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232101AbhHaSRv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 31 Aug 2021 14:17:51 -0400
Received: from mail-pj1-x102c.google.com (mail-pj1-x102c.google.com [IPv6:2607:f8b0:4864:20::102c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 46C52C061575
        for <netdev@vger.kernel.org>; Tue, 31 Aug 2021 11:16:56 -0700 (PDT)
Received: by mail-pj1-x102c.google.com with SMTP id w19-20020a17090aaf9300b00191e6d10a19so141307pjq.1
        for <netdev@vger.kernel.org>; Tue, 31 Aug 2021 11:16:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=DT6Ej/xM9f9Hu9npmNgQztje65zPU5BPR4Wv8PS5AlE=;
        b=SSMiYvStHPbsiH9jl2p0A4pvCSf0Rm6/m6PVB0tCWDKXvoqJxouibL7ehhz7ci6hbk
         0n59t969uxTjD8THQ6naOXLuDnkYPJ6Cn6Y8NFJIETaGxOzeVihyiwaAh1EtMJREf/0Z
         uuressL2prYy9dNCqw51ye9BjxZGna4bTrWzzUmp1H6vBXu38Frwr5tK5QXf226TV0P3
         SU62tW5F/y4fgJDNo0cs9DR4gf+lMRdFhdYo95X5gAlqmeWo2yjn0jB+CP2mgfMZDkWj
         PyyZzrq0805DIOBnorQsw2XzArpKFSnRVv6rHC9nD21LIoDgSNTgUw6NDtAw2HxurXw2
         Wovw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=DT6Ej/xM9f9Hu9npmNgQztje65zPU5BPR4Wv8PS5AlE=;
        b=cZemXFYCkUlSqqSnXt1s5FiVKFv8ZYBM1Jgnpvjkrlitmfg0FPHJgpId62EkHcBmHJ
         3wclfmcoDPygRmyNkvZMpO98smoK+KR//QdEa+4Kr9GSxe1n11217cVl6tO62pUTHY+Q
         ua+E5MPPkXT0RE5gE+TCCXJqs1fYI6N08bvAxR1aWRB1qFBvEXDngAG9m2yuGSaXyvkt
         Cc0v4tkuGuCewcKxQ++bpZLu778HIF+NBrHEmMWQxrRNJD/vt1BfbCdOsiE+1VAR6Bz+
         8k6xQD/jlPTAWWqGhC/2xw1P8tcV39uW6SxHkR8hklJtsQGBmdoBLVF9aKuczQo0AUlD
         4crg==
X-Gm-Message-State: AOAM5334PZzzpE83t99Ney0LZkU4kM+qKUY7lMGQkyJ9OHx4hmdiS/HT
        RzjVD1NP9j/OUsBxGjipIbRP6B5gO1fYqVB0PnBvLp1zfVo=
X-Google-Smtp-Source: ABdhPJxqlsUNzl9x3//u9T/7P6weAi5PFkXliwCRSkFzZGpUXPlQ8zjBSG43OeUFYKD9Pg34gTZyKIwBro3mMPTG3Nc=
X-Received: by 2002:a17:902:bd07:b029:12c:f4d5:fc6b with SMTP id
 p7-20020a170902bd07b029012cf4d5fc6bmr5817189pls.31.1630433815663; Tue, 31 Aug
 2021 11:16:55 -0700 (PDT)
MIME-Version: 1.0
References: <2fdc7b4e11c3283cd65c7cf77c81bd6687a32c20.1629844159.git.dcaratti@redhat.com>
 <CAM_iQpUryQ8Q9cd9Oiv=hxAgpqfCz=j4E=c=hskbPE2+VB-ZvQ@mail.gmail.com> <YS38YB9JTSHeYgJG@dcaratti.users.ipa.redhat.com>
In-Reply-To: <YS38YB9JTSHeYgJG@dcaratti.users.ipa.redhat.com>
From:   Cong Wang <xiyou.wangcong@gmail.com>
Date:   Tue, 31 Aug 2021 11:16:44 -0700
Message-ID: <CAM_iQpUnR-DvMBSWnagCJg98JMT_nMWNbQ8Ea0kC4yCBcFFRqA@mail.gmail.com>
Subject: Re: [PATH net] net/sched: ets: fix crash when flipping from 'strict'
 to 'quantum'
To:     Davide Caratti <dcaratti@redhat.com>
Cc:     Linux Kernel Network Developers <netdev@vger.kernel.org>,
        David Miller <davem@davemloft.net>,
        Jamal Hadi Salim <jhs@mojatatu.com>,
        Jiri Pirko <jiri@resnulli.us>,
        Jakub Kicinski <kuba@kernel.org>,
        Hangbin Liu <liuhangbin@gmail.com>,
        Petr Machata <petrm@mellanox.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Aug 31, 2021 at 2:54 AM Davide Caratti <dcaratti@redhat.com> wrote:
>
> hello Cong, thanks a lot for looking at this!
>
> On Mon, Aug 30, 2021 at 05:43:09PM -0700, Cong Wang wrote:
> > On Tue, Aug 24, 2021 at 3:34 PM Davide Caratti <dcaratti@redhat.com> wrote:
> > > When the change() function decreases the value of 'nstrict', we must take
> > > into account that packets might be already enqueued on a class that flips
> > > from 'strict' to 'quantum': otherwise that class will not be added to the
> > > bandwidth-sharing list. Then, a call to ets_qdisc_reset() will attempt to
> > > do list_del(&alist) with 'alist' filled with zero, hence the NULL pointer
> > > dereference.
> >
> > I am confused about how we end up having NULL in list head.
> >
> > From your changelog, you imply it happens when we change an existing
> > Qdisc, but I don't see any place that could set this list head to NULL.
> > list_del() clearly doesn't set NULL.
>
> right, the problem happens when we try to *decrease* the value of 'nstrict'
> while traffic is being loaded.
>
> ETS classes from 0 to nstrict - 1 don't initialize this list at all, nor they
> use it. The initialization happens when the first packet is enqueued to one of
> the bandwidth-sharing classes (from nstrict to nbands - 1), see [1]).
>
> However, if we modify the value of 'nstrict' while q->classes[i].qdisc->q.len is
> greater than zero, the list initialization is probably not going to happen, so
> the struct
>
> q->classes[i].alist
>
> remains filled with zero even since the first allocation, like you mentioned below:
>
> > But if it is a new Qdisc, Qdisc is allocated with zero's hence having NULL
> > as list head. However, in this case, q->nstrict should be 0 before the loop,
>
> ^^ this. But you are wrong, q->nstrict can be any value from 0 to 16 (inclusive)
> before the loop. As the value of 'nstrict' is reduced (e.g. from 4 to 0), the code
> can reach the loop in ets_qdisc_change() with the following 4 conditions
> simultaneously true:
>
> 1) nstrict = 0
> 2) q->nstrict = 4
> 3) q->classes[2].qdisc->q.qlen  greater than zero
> 4) q->classes[2].alist filled with 0
>
> then, the value of q->nstrict is updated to 0. After that, ets_qdisc_reset() can be
> called on unpatched Linux with the following 3 conditions simultaneously true:
>
> a) q->nstrict = 0
> b) q->classes[2].qdisc->q.qlen greater than zero
> c) q->classes[2].alist filled with 0
>
> that leads to the reported crash.
>
> > so I don't think your code helps at all as the for loop can't even be entered?
>
> The first code I tried was just doing INIT_LIST_HEAD(&q->classes[i].alist), with
> i ranging from nstrict to q->nstrict - 1: it fixed the crash in ets_qdisc_reset().
>
> But then I observed that classes changing from strict to quantum were not sharing
> any bandwidth at all, and they had a non-empty backlog even after I stopped all
> the traffic: so, I added the
>
>         if (q->classes[i].qdisc->q.qlen) {
>                 list_add_tail(&q->classes[i].alist, &q->active);
>                 q->classes[i].deficit = quanta[i];
>         }
>
> part, that updates the DRR list with non-empty classes that are changing from
> strict to DRR. After that, I verified that all classes were depleted correctly.
>
> On a second thought, this INIT_LIST_HEAD(&q->classes[i].alist) line is no more
> useful. If q->classes[i].qdisc->q.qlen is 0, either it remains 0 until the call
> to ets_qdisc_reset(), or some packet is enqueued after q->nstrict is updated,
> and the enqueueing of a 'first' packet [1] will fix the value of
> q->classes[i].alist.
> Finally, if q->classes[i].qdisc->q.qlen is bigger than zero, the list_add_tail()
> part of my patch covers the missing update of the DRR list. In all these cases,
> the NULL dereference in ets_qdisc_reset() is prevented.
>
> So, I can probably send a patch (for net-next, when it reopens) that removes
> this INIT_LIST_HEAD() line; anyway, its presence is harmless IMO. WDYT?

Actually I am thinking about the opposite, that is, always initializing the
list head. ;) Unless we always use list_add*() before list_del(), initializing
it unconditionally is a correct fix.

I do not doubt your patch works, however I worry that there might be
some other call paths which could call list_del() with the NULL.

Thanks.
