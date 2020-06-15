Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 68CE31FA2D3
	for <lists+netdev@lfdr.de>; Mon, 15 Jun 2020 23:33:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730099AbgFOVdQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 15 Jun 2020 17:33:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47176 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726207AbgFOVdQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 15 Jun 2020 17:33:16 -0400
Received: from mail-il1-x141.google.com (mail-il1-x141.google.com [IPv6:2607:f8b0:4864:20::141])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 338B2C061A0E
        for <netdev@vger.kernel.org>; Mon, 15 Jun 2020 14:33:16 -0700 (PDT)
Received: by mail-il1-x141.google.com with SMTP id g3so1552106ilq.10
        for <netdev@vger.kernel.org>; Mon, 15 Jun 2020 14:33:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=RT0AeqNPrKTpqCF0KBmf+SFFyf8HFRHYuKnmIl1yWj8=;
        b=vS+/OKyEf8/fVWchnS8moM3iNOoCkDpNpP5kHRaFhSfO+41e+gCMK4MEW9x4wAyQcp
         sOpk8fiEbVLSuiBdlxp7mWyU3ctDKSzwWh/4rLswd+fZS/pK5Pdo1PXFvb38lfSOXM6I
         Ga5FyRq7ebEPuVWk5fz2jEmUIy7U+SbqmxO9VxG9Sw8CKFaE10+/sGS3E5IWeouGQNg4
         QAj6I8DrAMiv+bKPYK8lQTAs6arspCq5Ykme1cVFOTI7u4gt+1Ibzsvanv1w6MoNdDpy
         Iw412G3hQOoMOhoxoQaQZGPG2cwRItszm2YuWUSzi0cZtCPYus7EFP74etOPoqLxuo1U
         Icfw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=RT0AeqNPrKTpqCF0KBmf+SFFyf8HFRHYuKnmIl1yWj8=;
        b=quZyUaRKuZccoU1rIo/5L+ynuQEoWB+DcgELPSJ1pDw1p392h2QAkgSt986Hwhwpck
         mHGRi0iSjEdho01T88sqWowKiXJbNyAzavzlAPo3zi/qAW8CPJFpi+Vl5xzo1omq2mFJ
         Q+YTsSiOiDgE+/o00VmdPqrBiqHtR5Kmq8K/c3La1s61YhBJP/PytZKxRKIEqr7fZ6BR
         i1W0Uq8lJW/oBIssKjMGfD2PRuwhaTjhsbXDceTE4RXOaHUkjdflO19+mC4Sd1Y+3P0M
         nkdtdK4Zv7GR6/YMqqnDuiq4aItq4/YMJH7rislnuQSpg51v7K8W0wmlvS+noseWskIl
         81pg==
X-Gm-Message-State: AOAM533kIROENl9Tmc/tlml1i+MGQfKd5ApLIZYJH6kbSULv9j+m0bdo
        3OUrzM6VRzxU83KFo9+g/5VW8gvFECvq5hfuLZSOOQ+W
X-Google-Smtp-Source: ABdhPJz/Ohu49Iax3vmSVJyYOAlDwHRqCfEq7yVC3zTNQmajP61vy1GTmhJNcVzZKMi/PL4KXuTsfNmYbUffawovPkM=
X-Received: by 2002:a92:db44:: with SMTP id w4mr12182989ilq.305.1592256795260;
 Mon, 15 Jun 2020 14:33:15 -0700 (PDT)
MIME-Version: 1.0
References: <20200608215301.26772-1-xiyou.wangcong@gmail.com>
 <CAMArcTUmqCqyyfs+vNtxoh_UsHZ2oZrcUkdWp8MPzW0tb6hKWA@mail.gmail.com>
 <CAM_iQpWM5Bxj-oEuF_mYBL9Qf-eWmoVbfPCo7a=SjOJ0LnMjAA@mail.gmail.com> <CAMArcTV6ZtW24CscBUt=OdRD4HdFnAYEJ-i6h5k5J8m0rfwnQA@mail.gmail.com>
In-Reply-To: <CAMArcTV6ZtW24CscBUt=OdRD4HdFnAYEJ-i6h5k5J8m0rfwnQA@mail.gmail.com>
From:   Cong Wang <xiyou.wangcong@gmail.com>
Date:   Mon, 15 Jun 2020 14:33:04 -0700
Message-ID: <CAM_iQpVpiujEgTc0WEfESPSa-DmqyObSycQ+S2Eve53eK6AD_g@mail.gmail.com>
Subject: Re: [Patch net] net: change addr_list_lock back to static key
To:     Taehee Yoo <ap420073@gmail.com>
Cc:     Netdev <netdev@vger.kernel.org>,
        syzbot+f3a0e80c34b3fc28ac5e@syzkaller.appspotmail.com,
        Dmitry Vyukov <dvyukov@google.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Jun 13, 2020 at 9:03 AM Taehee Yoo <ap420073@gmail.com> wrote:
>
> On Thu, 11 Jun 2020 at 08:21, Cong Wang <xiyou.wangcong@gmail.com> wrote:
> >
>
> Hi Cong :)
>
> > On Wed, Jun 10, 2020 at 7:48 AM Taehee Yoo <ap420073@gmail.com> wrote:
> > >
> > > On Tue, 9 Jun 2020 at 06:53, Cong Wang <xiyou.wangcong@gmail.com> wrote:
> > > >
> > > > +       lockdep_set_class_and_subclass(&dev->addr_list_lock,
> > > > +                                      &vlan_netdev_addr_lock_key,
> > > > +                                      subclass);
>
> In this patch, lockdep_set_class_and_subclass() is used.
> As far as I know, this function initializes lockdep key and subclass
> value with a given variable.
> A dev->lower_level variable is used as a subclass value in this patch.
> When dev->lower_level value is changed, the subclass value of this
> lockdep key is not changed automatically.
> If this value has to be changed, additional function is needed.

Hmm, but we pass a dynamic subclass to spin_lock_nested().

So I guess I should just remove all the
lockdep_set_class_and_subclass() and leave subclass to 0?

>
> >>>        netif_addr_lock_bh(from);
> In this function, internally spin_lock_bh() is used and this function
> might use an 'initialized subclass value' not a current dev->lower_level.
> At this point, I think the lockdep splat might occur.
>
> +static inline void netif_addr_lock_nested(struct net_device *dev)
> +{
> +       spin_lock_nested(&dev->addr_list_lock, dev->lower_level);
> +}
> In this patch, you used netif_addr_lock_nested() too.
> These two subclass values could be different.
> But I'm not sure whether using spin_lock_nested with two different
> subclass values are the right way or not.

Yeah, as long as dev->lower_level is different, it should be different
subclass. I assume dev->lower_level is automatically adjusted
whenever the topology changes, like the vlan over bond case above.

Thanks.
