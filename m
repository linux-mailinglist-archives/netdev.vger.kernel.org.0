Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2D5C9BD590
	for <lists+netdev@lfdr.de>; Wed, 25 Sep 2019 01:48:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2442084AbfIXXsM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 24 Sep 2019 19:48:12 -0400
Received: from mail-io1-f66.google.com ([209.85.166.66]:45048 "EHLO
        mail-io1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2389370AbfIXXsM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 24 Sep 2019 19:48:12 -0400
Received: by mail-io1-f66.google.com with SMTP id j4so8811719iog.11
        for <netdev@vger.kernel.org>; Tue, 24 Sep 2019 16:48:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=gO/seRVCOqUmAmUtc997N8jcHWE4RkEHgN9QI1dAzJo=;
        b=c0FCnxY+VDfBbgz0HDkMUlx3suOWzm0o0IvSu9t9coYB/pxLiRtINYHP5x94U9GaqQ
         6b5CN2iR+px4CiDB98Sxl16aGbTSRc6nIvp0NrtgfTMimGlsWDYEofAPI0EGhOMcwZMJ
         VbNokA14JyqI2IdA9HcnZ+CMG/lD8vITGzLxE=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=gO/seRVCOqUmAmUtc997N8jcHWE4RkEHgN9QI1dAzJo=;
        b=PvROCqsYb3jZgSfe7fw4Dg6pbYbReWP8GNyiNOViRPZUFXnOcnU4EkwSFbyyvxHrM/
         BAR6GnAI0RUruZ7VC2h2rqMeu757F5E02/gig+5MhhH7RllLsGmXT/9lomBUTzPaov8t
         m1GNk+LdIXr+HkyBssU/VpyXMt2fhx87LUXGoRYVZ+EVrshu7wIfdm/wNX6ma/Gjfhl1
         RKKyqrX/0dsiL88xIdHpzegnsqYlxh2cV5Dv0W28tSc8yk9Iu0sLEq5bLLXasMUnAbxJ
         a02QqainDrMec9vRKWoHrwZRZr40iIdEETNWsBQE5LHiKsbIH96SGgD+wN0yBST3UXKG
         GskA==
X-Gm-Message-State: APjAAAXSIhq9UwBnr0HAzu5FSgi4Wt+TDdfTMDhQgpogYUrS9RJ2soV2
        HdSo5IIeiC0gu3/KCpQlHb3zLgf5cM+hMLLHOjtOgQ==
X-Google-Smtp-Source: APXvYqxcYfd9t6mpPwS1UbHJCd/PhaoHvzE6iQUonpnPifAsocruTk36k/xwX9TLvXEjuvUH/bZYDp/JT8/JJWu9psk=
X-Received: by 2002:a02:7b0d:: with SMTP id q13mr1881936jac.114.1569368891164;
 Tue, 24 Sep 2019 16:48:11 -0700 (PDT)
MIME-Version: 1.0
References: <20190923222657.253628-1-pmalani@chromium.org> <0835B3720019904CB8F7AA43166CEEB2F18E1587@RTITMBSVM03.realtek.com.tw>
In-Reply-To: <0835B3720019904CB8F7AA43166CEEB2F18E1587@RTITMBSVM03.realtek.com.tw>
From:   Grant Grundler <grundler@chromium.org>
Date:   Tue, 24 Sep 2019 16:47:59 -0700
Message-ID: <CANEJEGsN44m190YSw=NYozV72Dt3fuPohUwWEMH2XWWBGsCgBg@mail.gmail.com>
Subject: Re: [PATCH] r8152: Use guard clause and fix comment typos
To:     Hayes Wang <hayeswang@realtek.com>
Cc:     Prashant Malani <pmalani@chromium.org>,
        "grundler@chromium.org" <grundler@chromium.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        nic_swsd <nic_swsd@realtek.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Sep 23, 2019 at 7:47 PM Hayes Wang <hayeswang@realtek.com> wrote:
>
> Prashant Malani [mailto:pmalani@chromium.org]
> > Sent: Tuesday, September 24, 2019 6:27 AM
> > To: Hayes Wang
> [...]
> > -     do {
> > +     while (1) {
> >               struct tx_agg *agg;
> > +             struct net_device *netdev = tp->netdev;
> >
> >               if (skb_queue_empty(&tp->tx_queue))
> >                       break;
> > @@ -2188,26 +2189,25 @@ static void tx_bottom(struct r8152 *tp)
> >                       break;
> >
> >               res = r8152_tx_agg_fill(tp, agg);
> > -             if (res) {
> > -                     struct net_device *netdev = tp->netdev;
> > +             if (!res)
> > +                     break;
>
> I let the loop run continually until an error occurs or the queue is empty.
> However, you stop the loop when r8152_tx_agg_fill() is successful.

Hayes,
Are you sure about both assertions?
The do/while loop exits if "res == 0". Isn't that the same as "!res"?

> If an error occurs continually, the loop may not be broken.

And what prevents that from happening with the current code?

Should current code break out of the loop in -ENODEV case, right?

That would be more obvious if the code inside the loop were:
    ...
    res = r8152_tx_agg_fill(tp, agg);
    if (res == -ENODEV) {
       ...
       break;
     }
     if (!res)
         break;
    ...

(Or whatever the right code is to "loop until an error occurs or queue
is empty").

cheers,
grant

>
> > -                     if (res == -ENODEV) {
> > -                             rtl_set_unplug(tp);
> > -                             netif_device_detach(netdev);
> > -                     } else {
> > -                             struct net_device_stats *stats = &netdev->stats;
> > -                             unsigned long flags;
> > +             if (res == -ENODEV) {
> > +                     rtl_set_unplug(tp);
> > +                     netif_device_detach(netdev);
> > +             } else {
> > +                     struct net_device_stats *stats = &netdev->stats;
> > +                     unsigned long flags;
> >
> > -                             netif_warn(tp, tx_err, netdev,
> > -                                        "failed tx_urb %d\n", res);
> > -                             stats->tx_dropped += agg->skb_num;
> > +                     netif_warn(tp, tx_err, netdev,
> > +                                "failed tx_urb %d\n", res);
> > +                     stats->tx_dropped += agg->skb_num;
> >
> > -                             spin_lock_irqsave(&tp->tx_lock, flags);
> > -                             list_add_tail(&agg->list, &tp->tx_free);
> > -                             spin_unlock_irqrestore(&tp->tx_lock, flags);
> > -                     }
> > +                     spin_lock_irqsave(&tp->tx_lock, flags);
> > +                     list_add_tail(&agg->list, &tp->tx_free);
> > +                     spin_unlock_irqrestore(&tp->tx_lock, flags);
> >               }
> > -     } while (res == 0);
> > +     }
>
> I think the behavior is different from the current one.
>
> Best Regards,
> Hayes
>
