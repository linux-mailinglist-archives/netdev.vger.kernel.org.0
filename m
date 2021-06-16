Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7471B3A8EC2
	for <lists+netdev@lfdr.de>; Wed, 16 Jun 2021 04:17:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231360AbhFPCTQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 15 Jun 2021 22:19:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57844 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229582AbhFPCTQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 15 Jun 2021 22:19:16 -0400
Received: from mail-ej1-x636.google.com (mail-ej1-x636.google.com [IPv6:2a00:1450:4864:20::636])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DE647C061574;
        Tue, 15 Jun 2021 19:17:09 -0700 (PDT)
Received: by mail-ej1-x636.google.com with SMTP id g8so1089187ejx.1;
        Tue, 15 Jun 2021 19:17:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=MCDor/w6lKVwI2iurzUF4jk7w2SeMQAsUxGeBVaSZPs=;
        b=dhHDjaQB0VcAtcFpKYUpQwrCCvyMHaJbQ2NadBKT9slA7jTAgkhmBG1SeiI/uTywu+
         47/dAM4Zfwbn+dSpnhURz6NB2NKJDmI+PNF1wwtDRqlrT17SGcvPEeiHtGAbGUU7reOS
         BNqGSIGuJ8olSKQTU4DInBtUocZC+MM0krek/Ys2R0G4jTLUZfy+/O7/ykgXkiQoaGsU
         R8xOPr7waZ8136DVHcfgetVQ4V1xIP82fe7474YFuBVWG+hjggoMKxRtYvwJ6SJl7aRd
         zliRXIQFk5t7w8q5j5PQqMAJaxYFPC336gJHXzpuYnA9LnbDdk4qyEg2BpvBcsp9t7n9
         aVjQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=MCDor/w6lKVwI2iurzUF4jk7w2SeMQAsUxGeBVaSZPs=;
        b=GUfUzdo+q22CFzIfbLl/wQBGn33GUFODgMdJfqiOfhkbqB5wEHakyImMfKu2ZcqCuM
         9jRNZIWRnyjhbjR26o0onEvOUhhOP0UfSXb9j7RuS0Nauk2wURv+y8U9zCY3so+Bge5F
         7Fu67/B/KfTebCzF929iHFw9ZI0ockIAwFNvI4lKWMhFYdomA+bFPhL13mJOVsYBQ8tz
         EODGB0ISTxiDrskmzvOOlKU5Cl6Ye9oSxjJ5DjACTu9aYV6T9klyqvZda70OWhtj5kC4
         YjjlWOcgA5UwsPWdC1gzi1uBcxMWufObnAUffEy0YUSXfNxsMJiA121+w8a2e9nme5jx
         NVhA==
X-Gm-Message-State: AOAM531RE/g1X467yke3VkGlNzudyL9MuSqmzB82+m+qAwCHr92vMJPT
        RYqrfH1NGNv9Uc0kCCO8s5vb6PQWlOJqLyWe0tg=
X-Google-Smtp-Source: ABdhPJziL9hg6SBudauv+KFlVosSoq2YVCxWUIEj63Q1HfX+0Y8c88/ypFzaOz95yJQ/fY7X5T96f99mGuwnOzyFRIw=
X-Received: by 2002:a17:906:3c44:: with SMTP id i4mr2595685ejg.135.1623809828364;
 Tue, 15 Jun 2021 19:17:08 -0700 (PDT)
MIME-Version: 1.0
References: <20210614153712.2172662-1-mudongliangabcd@gmail.com>
 <20210614190045.5b4c92e6@gmail.com> <CAD-N9QVG40CqgkHb1w68FL-d1LkTzjcAhF9O8whmzWo67=4KJg@mail.gmail.com>
 <20210615163108.4e17e119@gmail.com>
In-Reply-To: <20210615163108.4e17e119@gmail.com>
From:   Dongliang Mu <mudongliangabcd@gmail.com>
Date:   Wed, 16 Jun 2021 10:16:42 +0800
Message-ID: <CAD-N9QXTu1P=2EKPVRWKOD1dfdfq-YY=MP5Yhv3Sd75Cff0bKg@mail.gmail.com>
Subject: Re: [PATCH] net: usb: fix possible use-after-free in smsc75xx_bind
To:     Pavel Skripkin <paskripkin@gmail.com>
Cc:     Steve Glendinning <steve.glendinning@shawell.net>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        linux-usb@vger.kernel.org,
        linux-kernel <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jun 15, 2021 at 9:31 PM Pavel Skripkin <paskripkin@gmail.com> wrote:
>
> On Tue, 15 Jun 2021 07:01:13 +0800
> Dongliang Mu <mudongliangabcd@gmail.com> wrote:
>
> > On Tue, Jun 15, 2021 at 12:00 AM Pavel Skripkin
> > <paskripkin@gmail.com> wrote:
> > >
> > > On Mon, 14 Jun 2021 23:37:12 +0800
> > > Dongliang Mu <mudongliangabcd@gmail.com> wrote:
> > >
> > > > The commit 46a8b29c6306 ("net: usb: fix memory leak in
> > > > smsc75xx_bind") fails to clean up the work scheduled in
> > > > smsc75xx_reset-> smsc75xx_set_multicast, which leads to
> > > > use-after-free if the work is scheduled to start after the
> > > > deallocation. In addition, this patch also removes one dangling
> > > > pointer - dev->data[0].
> > > >
> > > > This patch calls cancel_work_sync to cancel the schedule work and
> > > > set the dangling pointer to NULL.
> > > >
> > > > Fixes: 46a8b29c6306 ("net: usb: fix memory leak in smsc75xx_bind")
> > > > Signed-off-by: Dongliang Mu <mudongliangabcd@gmail.com>
> > > > ---
> > > >  drivers/net/usb/smsc75xx.c | 3 +++
> > > >  1 file changed, 3 insertions(+)
> > > >
> > > > diff --git a/drivers/net/usb/smsc75xx.c
> > > > b/drivers/net/usb/smsc75xx.c index b286993da67c..f81740fcc8d5
> > > > 100644 --- a/drivers/net/usb/smsc75xx.c
> > > > +++ b/drivers/net/usb/smsc75xx.c
> > > > @@ -1504,7 +1504,10 @@ static int smsc75xx_bind(struct usbnet
> > > > *dev, struct usb_interface *intf) return 0;
> > > >
> > > >  err:
> > > > +     cancel_work_sync(&pdata->set_multicast);
> > > >       kfree(pdata);
> > > > +     pdata = NULL;
> > > > +     dev->data[0] = 0;
> > > >       return ret;
> > > >  }
> > > >
> > >
> > > Hi, Dongliang!
> > >
> > > Just my thougth about this patch:
> > >
> > > INIT_WORK(&pdata->set_multicast, smsc75xx_deferred_multicast_write);
> > > does not queue anything, it just initalizes list structure and
> > > assigns callback function. The actual work sheduling happens in
> > > smsc75xx_set_multicast() which is smsc75xx_netdev_ops member.
> > >
> >
> > Yes, you are right. However, as written in the commit message,
> > smsc75xx_set_multicast will be called by smsc75xx_reset [1].
> >
> > If smsc75xx_set_multicast is called before any check failure occurs,
> > this work(set_multicast) will be queued into the global list with
> >
> > schedule_work(&pdata->set_multicast); [2]
>
> Ah, I missed it, sorry :)
>
> Maybe, small optimization for error handling path like:
>
> cancel_work:
>         cancel_work_sync(&pdata->set_multicast);
>         dev->data[0] = 0;
> free_pdata:
>         kfree(pdata);
>         return ret;
>
>
> is suitbale here.

I agree with this style of error handling. However, I need to adjust
the location of dev->data[0] = 0 after kfree(pdata) because if there
still leaves a dangling pointer it directly goes to free_pdata.

>
> >
> > At last, if the pdata or dev->data[0] is freed before the
> > set_multicast really executes, it may lead to a UAF. Is this correct?
> >
> > BTW, even if the above is true, I don't know if I call the API
> > ``cancel_work_sync(&pdata->set_multicast)'' properly if the
> > schedule_work is not called.
> >
>
> Yeah, it will be ok.

Thanks for the confirmation. I've tested it under the previous kernel
crash. It works fine.

I will send a v2 patch quickly.

>
> > [1]
> > https://elixir.bootlin.com/linux/latest/source/drivers/net/usb/smsc75xx.c#L1322
> >
> > [2]
> > https://elixir.bootlin.com/linux/latest/source/drivers/net/usb/smsc75xx.c#L583
> >
> > > In case of any error in smsc75xx_bind() the device registration
> > > fails and smsc75xx_netdev_ops won't be registered, so, i guess,
> > > there is no chance of UAF.
> > >
> > >
> > > Am I missing something? :)
> > >
> > >
> > >
> > > With regards,
> > > Pavel Skripkin
>
>
>
>
> With regards,
> Pavel Skripkin
