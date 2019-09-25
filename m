Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3386CBD5BC
	for <lists+netdev@lfdr.de>; Wed, 25 Sep 2019 02:28:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389314AbfIYA2Q (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 24 Sep 2019 20:28:16 -0400
Received: from mail-io1-f68.google.com ([209.85.166.68]:45668 "EHLO
        mail-io1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2388529AbfIYA2Q (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 24 Sep 2019 20:28:16 -0400
Received: by mail-io1-f68.google.com with SMTP id c25so9010274iot.12
        for <netdev@vger.kernel.org>; Tue, 24 Sep 2019 17:28:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=ACkPD/hvqVN7g/rXVjH4xawxRcRfxUKLNIyzwYu/r7g=;
        b=VMPxJ+1cWdCfHgICH2HzjkZiAIgjRUcjRSQr3qRcffqq2dZPAqHQs1Uwt/HegMUAFk
         yCSS2ndOONcwgyORHIFfL9stZrQWq76QwCBG+pHC6ArKkmswn37au6mR+YqNFy8N/ft0
         B/HT1E6puah7Q9gaBTmSRV6KDw/TOZ8VJzMkY=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=ACkPD/hvqVN7g/rXVjH4xawxRcRfxUKLNIyzwYu/r7g=;
        b=pJ//qKXota3DtGo3/4zwT26CsL50ibGui5RbebmxQfe+4fZQRE3Q8R5BGDjaL6yLWK
         +Sw9PYoR3XHwk7T1HOBhtqHdo/c5UIfPQaR9F6VKbygl6CxOg1SC/IGgr7ReH/pBpDx9
         WVhoKgUsnceHq82V+ILw220yRGPVpkhFkLh6PQMUXun1VltntGjfK7NgcIDEtBKeVqnS
         siE6AACX2xzeJVxHlu/0GZGy1mort256D6rmiuFp4ijTQ360UA4SQnNjkCGKwgoRWbxi
         cdiJy0L3vuv3qc6i3yQOxi2lWuxtMWAGpKmbIBJxWGGla66v1BqK/yQMO04QFtLTM7Ei
         sqiw==
X-Gm-Message-State: APjAAAUEfpY7yO/fml7namM0k02A4HoW132Bs637TZHrHOncbTstj96y
        v8SV+ZgbQ1tKdxTWc5wxO9jz2I8Uw0NPY1Ovdx3o0A==
X-Google-Smtp-Source: APXvYqy+7HUbFM67IXR06PRGU2o5KHCWIdfNDKQp4KGqiv6QQvG1NdA1cTO5P9NuJP7o2Z4uOhOpk66i1qwDTBhqk1A=
X-Received: by 2002:a6b:e007:: with SMTP id z7mr7063614iog.167.1569371293245;
 Tue, 24 Sep 2019 17:28:13 -0700 (PDT)
MIME-Version: 1.0
References: <20190923222657.253628-1-pmalani@chromium.org> <0835B3720019904CB8F7AA43166CEEB2F18E1587@RTITMBSVM03.realtek.com.tw>
 <CANEJEGsN44m190YSw=NYozV72Dt3fuPohUwWEMH2XWWBGsCgBg@mail.gmail.com>
In-Reply-To: <CANEJEGsN44m190YSw=NYozV72Dt3fuPohUwWEMH2XWWBGsCgBg@mail.gmail.com>
From:   Grant Grundler <grundler@chromium.org>
Date:   Tue, 24 Sep 2019 17:28:01 -0700
Message-ID: <CANEJEGt4UbxUhP=BcVT3ThhAk-Fz9L+ULrNKygcZ9K0Q=A7CLw@mail.gmail.com>
Subject: Re: [PATCH] r8152: Use guard clause and fix comment typos
To:     Grant Grundler <grundler@chromium.org>
Cc:     Hayes Wang <hayeswang@realtek.com>,
        Prashant Malani <pmalani@chromium.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        nic_swsd <nic_swsd@realtek.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Sep 24, 2019 at 4:47 PM Grant Grundler <grundler@chromium.org> wrote:
>
> On Mon, Sep 23, 2019 at 7:47 PM Hayes Wang <hayeswang@realtek.com> wrote:
> >
> > Prashant Malani [mailto:pmalani@chromium.org]
> > > Sent: Tuesday, September 24, 2019 6:27 AM
> > > To: Hayes Wang
> > [...]
> > > -     do {
> > > +     while (1) {
> > >               struct tx_agg *agg;
> > > +             struct net_device *netdev = tp->netdev;
> > >
> > >               if (skb_queue_empty(&tp->tx_queue))
> > >                       break;
> > > @@ -2188,26 +2189,25 @@ static void tx_bottom(struct r8152 *tp)
> > >                       break;
> > >
> > >               res = r8152_tx_agg_fill(tp, agg);
> > > -             if (res) {
> > > -                     struct net_device *netdev = tp->netdev;
> > > +             if (!res)
> > > +                     break;
> >
> > I let the loop run continually until an error occurs or the queue is empty.
> > However, you stop the loop when r8152_tx_agg_fill() is successful.
>
> Hayes,
> Are you sure about both assertions?
> The do/while loop exits if "res == 0". Isn't that the same as "!res"?

Hayes,
Sorry, You are correct.

thanks,
grant

>
> > If an error occurs continually, the loop may not be broken.
>
> And what prevents that from happening with the current code?
>
> Should current code break out of the loop in -ENODEV case, right?
>
> That would be more obvious if the code inside the loop were:
>     ...
>     res = r8152_tx_agg_fill(tp, agg);
>     if (res == -ENODEV) {
>        ...
>        break;
>      }
>      if (!res)
>          break;
>     ...
>
> (Or whatever the right code is to "loop until an error occurs or queue
> is empty").
>
> cheers,
> grant
>
> >
> > > -                     if (res == -ENODEV) {
> > > -                             rtl_set_unplug(tp);
> > > -                             netif_device_detach(netdev);
> > > -                     } else {
> > > -                             struct net_device_stats *stats = &netdev->stats;
> > > -                             unsigned long flags;
> > > +             if (res == -ENODEV) {
> > > +                     rtl_set_unplug(tp);
> > > +                     netif_device_detach(netdev);
> > > +             } else {
> > > +                     struct net_device_stats *stats = &netdev->stats;
> > > +                     unsigned long flags;
> > >
> > > -                             netif_warn(tp, tx_err, netdev,
> > > -                                        "failed tx_urb %d\n", res);
> > > -                             stats->tx_dropped += agg->skb_num;
> > > +                     netif_warn(tp, tx_err, netdev,
> > > +                                "failed tx_urb %d\n", res);
> > > +                     stats->tx_dropped += agg->skb_num;
> > >
> > > -                             spin_lock_irqsave(&tp->tx_lock, flags);
> > > -                             list_add_tail(&agg->list, &tp->tx_free);
> > > -                             spin_unlock_irqrestore(&tp->tx_lock, flags);
> > > -                     }
> > > +                     spin_lock_irqsave(&tp->tx_lock, flags);
> > > +                     list_add_tail(&agg->list, &tp->tx_free);
> > > +                     spin_unlock_irqrestore(&tp->tx_lock, flags);
> > >               }
> > > -     } while (res == 0);
> > > +     }
> >
> > I think the behavior is different from the current one.
> >
> > Best Regards,
> > Hayes
> >
