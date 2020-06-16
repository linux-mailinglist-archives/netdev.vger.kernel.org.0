Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 77B631FB55D
	for <lists+netdev@lfdr.de>; Tue, 16 Jun 2020 17:03:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729774AbgFPPDl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 16 Jun 2020 11:03:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39714 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729166AbgFPPDk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 16 Jun 2020 11:03:40 -0400
Received: from mail-lf1-x143.google.com (mail-lf1-x143.google.com [IPv6:2a00:1450:4864:20::143])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6384DC061573
        for <netdev@vger.kernel.org>; Tue, 16 Jun 2020 08:03:40 -0700 (PDT)
Received: by mail-lf1-x143.google.com with SMTP id w15so11924777lfe.11
        for <netdev@vger.kernel.org>; Tue, 16 Jun 2020 08:03:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=rAiWQjEg9vJCDT0gkYzX9X93cIN9T7m9vwd7MSJD0Oo=;
        b=HXTyaP4b232YifVgr3zSAaOMc8rCAfQwjv1GvQuJBV+TydiJmfIlXzTQ0U3oOvgFWm
         j+qSXN4TzCDfFzo5xXSs1dYCqWxHXivUp1YxQiDkyqtN3DEZn4Mb8lUi52FSmePwOzFv
         OdLfMLLvOBFByjQ/DQ4HHk5E66xg1DMM8pgu0GxlDFUtZVP5m9R/qcViM+Pa6k3t7Tt9
         n/Ws4/Q8m9NIC9W1dT1UEusCiRW4fg9axrwE8Q9gwrwN2wvrJv2uZLPY3mB9NhoFcRad
         4yG/nNynKzhoPmFZ2hZptFr+59mTp8VI416LXtJ9/ccccejEOkUwAy8ez2cjvCcJwmKJ
         GjGQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=rAiWQjEg9vJCDT0gkYzX9X93cIN9T7m9vwd7MSJD0Oo=;
        b=hNVotCQmtmvCHqgOW7IGqk5i3gnkoMw8ZH4u41lCyuehEz2YCntRoHBrPSEyJJVPVe
         QwqUy1Ax6FGt71GdpeT3XCUCULoJbzdnXKFUBKvkHlkrqAXiF3SHb9FqpHAoyKKG9vQ4
         WWyHMpxKiX6/OzCabhF/cbXQLc1jk37neByLmBNMkkbfq8h2uzcXoRyN4hnCeruYdoAP
         IkoOKnYPanWIDZ8JBhIwqvFryiIC7Ybzww9gonpe8o07Uzfg6N7c4WqDuwBQWzvsghjL
         jK1n3hSeHB6SjLgbUeoZG6pMVCCALrjKXam5O+wCOGZxnB2+8zEIzUO7n01RJGVtklx0
         z3uQ==
X-Gm-Message-State: AOAM530atjjOHhn0EQJ48H0iRpqiYgfIsLa0h4zTvKi9sOQ07/isY21h
        lx1zpvigLjxUKAEpr/9Y3sdgjswy4ZR1IxGJYcI=
X-Google-Smtp-Source: ABdhPJzkgsXPDy9MxE6UVYV7zDHY99O7sP1mdbius49q8gcCUhBTuMty1mJavCn7QPtzlhPG9XYIfmFejz3yw3i9sUA=
X-Received: by 2002:a19:c187:: with SMTP id r129mr1966066lff.129.1592319818725;
 Tue, 16 Jun 2020 08:03:38 -0700 (PDT)
MIME-Version: 1.0
References: <20200608215301.26772-1-xiyou.wangcong@gmail.com>
 <CAMArcTUmqCqyyfs+vNtxoh_UsHZ2oZrcUkdWp8MPzW0tb6hKWA@mail.gmail.com>
 <CAM_iQpWM5Bxj-oEuF_mYBL9Qf-eWmoVbfPCo7a=SjOJ0LnMjAA@mail.gmail.com>
 <CAMArcTV6ZtW24CscBUt=OdRD4HdFnAYEJ-i6h5k5J8m0rfwnQA@mail.gmail.com> <CAM_iQpVpiujEgTc0WEfESPSa-DmqyObSycQ+S2Eve53eK6AD_g@mail.gmail.com>
In-Reply-To: <CAM_iQpVpiujEgTc0WEfESPSa-DmqyObSycQ+S2Eve53eK6AD_g@mail.gmail.com>
From:   Taehee Yoo <ap420073@gmail.com>
Date:   Wed, 17 Jun 2020 00:03:27 +0900
Message-ID: <CAMArcTV6YQPC6uo2NHER41H++XnCG+LW7ZXDgvF_snYmMZON3Q@mail.gmail.com>
Subject: Re: [Patch net] net: change addr_list_lock back to static key
To:     Cong Wang <xiyou.wangcong@gmail.com>
Cc:     Netdev <netdev@vger.kernel.org>,
        syzbot+f3a0e80c34b3fc28ac5e@syzkaller.appspotmail.com,
        Dmitry Vyukov <dvyukov@google.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 16 Jun 2020 at 06:33, Cong Wang <xiyou.wangcong@gmail.com> wrote:
>

Hi Cong,

> On Sat, Jun 13, 2020 at 9:03 AM Taehee Yoo <ap420073@gmail.com> wrote:
> >
> > On Thu, 11 Jun 2020 at 08:21, Cong Wang <xiyou.wangcong@gmail.com> wrote:
> > >
> >
> > Hi Cong :)
> >
> > > On Wed, Jun 10, 2020 at 7:48 AM Taehee Yoo <ap420073@gmail.com> wrote:
> > > >
> > > > On Tue, 9 Jun 2020 at 06:53, Cong Wang <xiyou.wangcong@gmail.com> wrote:
> > > > >
> > > > > +       lockdep_set_class_and_subclass(&dev->addr_list_lock,
> > > > > +                                      &vlan_netdev_addr_lock_key,
> > > > > +                                      subclass);
> >
> > In this patch, lockdep_set_class_and_subclass() is used.
> > As far as I know, this function initializes lockdep key and subclass
> > value with a given variable.
> > A dev->lower_level variable is used as a subclass value in this patch.
> > When dev->lower_level value is changed, the subclass value of this
> > lockdep key is not changed automatically.
> > If this value has to be changed, additional function is needed.
>
> Hmm, but we pass a dynamic subclass to spin_lock_nested().
>
> So I guess I should just remove all the
> lockdep_set_class_and_subclass() and leave subclass to 0?
>

I agree with that.
And, do you have any plan to replace netif_addr_lock_bh() with
netif_addr_lock_nested()?
(Of course, it needs BH handling code)
I'm not sure but I think it would be needed.

> >
> > >>>        netif_addr_lock_bh(from);
> > In this function, internally spin_lock_bh() is used and this function
> > might use an 'initialized subclass value' not a current dev->lower_level.
> > At this point, I think the lockdep splat might occur.
> >
> > +static inline void netif_addr_lock_nested(struct net_device *dev)
> > +{
> > +       spin_lock_nested(&dev->addr_list_lock, dev->lower_level);
> > +}
> > In this patch, you used netif_addr_lock_nested() too.
> > These two subclass values could be different.
> > But I'm not sure whether using spin_lock_nested with two different
> > subclass values are the right way or not.
>
> Yeah, as long as dev->lower_level is different, it should be different
> subclass. I assume dev->lower_level is automatically adjusted
> whenever the topology changes, like the vlan over bond case above.
>

Yes, you're right.

Thanks!
Taehee Yoo
