Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 466A03A7FE5
	for <lists+netdev@lfdr.de>; Tue, 15 Jun 2021 15:31:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231486AbhFONdd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 15 Jun 2021 09:33:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55008 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231740AbhFONdT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 15 Jun 2021 09:33:19 -0400
Received: from mail-lf1-x129.google.com (mail-lf1-x129.google.com [IPv6:2a00:1450:4864:20::129])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EE258C0611C0;
        Tue, 15 Jun 2021 06:31:14 -0700 (PDT)
Received: by mail-lf1-x129.google.com with SMTP id r198so27033832lff.11;
        Tue, 15 Jun 2021 06:31:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=X7QyFpMRaIz1rkNDj3CFhI3o4WQb4st3n6J/P7lJ3Sg=;
        b=prwqd50vb1jED1ChJkbgOKTYUSRG3d8znIigmJ36m6usDi8dy6y0j1aw6lRsUEIzlC
         2zzvTmV6pHr7AMRGDyYFgcnUWdRHhv17ZTGzBhaKN0agg+wsbRd7QRyxocsZPT1vlHP8
         2vxIWP+7m4fBmMWttxahSsU97OhQleqE07OFEqpdAFK3Jup/2bJxNM5qtLFSeKF+jiIH
         IFdcX80N81WJ1e9q7o2pgOPP8Ui0cIq/hsTCzyaNQdHcjAPvbU8Arg3FNEElWgIbbUtE
         zqcv00r566ut5Veq4+x1Ool2fN7WE2A2agNkbAkPnngPjDxa9kGF6XgQ+B4Ye1Sip8iV
         U8oQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=X7QyFpMRaIz1rkNDj3CFhI3o4WQb4st3n6J/P7lJ3Sg=;
        b=tAGF4vsIIAVphKX3n2ri6o7cLevZ1vZxV4aNgByQfIXbrGHwyrZ48d0Hgq6uOMJKUj
         wIX1rTqLZrxHxp/7wsXeKJf4MeIJgu7q9Xt4oj+CcG12vAEd/rfjcBFrGzBLog5TZcpZ
         xPCKN5vS2/jRn2UP5TFW+f8vnt08UyKl71H4Ij9B3o+v7QN37XhuL+x/d20PI96VKSEL
         ZvvdsX55GX7aaQphKQAAdNvxqEdg9iMgMP/AephbFAILdoMUZ/VRLhZ5lQuSaA5cyEXy
         gYen85OSA1vJlFzzfdi467snUyz0RNwQKtMwHPjquS7KoKbSqGErHKlXeRce6ymIKKTZ
         aXkg==
X-Gm-Message-State: AOAM533/MnHwsP+FINhjLhwqbG57jePyG8lIO8Lgmoa4lRmZJGDQ+25K
        kzU/C1e5mCDJPN6gmXAlPtE=
X-Google-Smtp-Source: ABdhPJw94FAsLDrGBTvWO123dKNb9daIY+CCi2QI8rsnF4OSdz/E2yANZv47gE84FfW4plSn8qOD2Q==
X-Received: by 2002:a05:6512:944:: with SMTP id u4mr15978195lft.30.1623763873226;
        Tue, 15 Jun 2021 06:31:13 -0700 (PDT)
Received: from localhost.localdomain ([94.103.229.24])
        by smtp.gmail.com with ESMTPSA id z8sm1806752lfg.243.2021.06.15.06.31.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 15 Jun 2021 06:31:12 -0700 (PDT)
Date:   Tue, 15 Jun 2021 16:31:08 +0300
From:   Pavel Skripkin <paskripkin@gmail.com>
To:     Dongliang Mu <mudongliangabcd@gmail.com>
Cc:     Steve Glendinning <steve.glendinning@shawell.net>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        linux-usb@vger.kernel.org,
        linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] net: usb: fix possible use-after-free in smsc75xx_bind
Message-ID: <20210615163108.4e17e119@gmail.com>
In-Reply-To: <CAD-N9QVG40CqgkHb1w68FL-d1LkTzjcAhF9O8whmzWo67=4KJg@mail.gmail.com>
References: <20210614153712.2172662-1-mudongliangabcd@gmail.com>
        <20210614190045.5b4c92e6@gmail.com>
        <CAD-N9QVG40CqgkHb1w68FL-d1LkTzjcAhF9O8whmzWo67=4KJg@mail.gmail.com>
X-Mailer: Claws Mail 3.17.8 (GTK+ 2.24.33; x86_64-suse-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 15 Jun 2021 07:01:13 +0800
Dongliang Mu <mudongliangabcd@gmail.com> wrote:

> On Tue, Jun 15, 2021 at 12:00 AM Pavel Skripkin
> <paskripkin@gmail.com> wrote:
> >
> > On Mon, 14 Jun 2021 23:37:12 +0800
> > Dongliang Mu <mudongliangabcd@gmail.com> wrote:
> >
> > > The commit 46a8b29c6306 ("net: usb: fix memory leak in
> > > smsc75xx_bind") fails to clean up the work scheduled in
> > > smsc75xx_reset-> smsc75xx_set_multicast, which leads to
> > > use-after-free if the work is scheduled to start after the
> > > deallocation. In addition, this patch also removes one dangling
> > > pointer - dev->data[0].
> > >
> > > This patch calls cancel_work_sync to cancel the schedule work and
> > > set the dangling pointer to NULL.
> > >
> > > Fixes: 46a8b29c6306 ("net: usb: fix memory leak in smsc75xx_bind")
> > > Signed-off-by: Dongliang Mu <mudongliangabcd@gmail.com>
> > > ---
> > >  drivers/net/usb/smsc75xx.c | 3 +++
> > >  1 file changed, 3 insertions(+)
> > >
> > > diff --git a/drivers/net/usb/smsc75xx.c
> > > b/drivers/net/usb/smsc75xx.c index b286993da67c..f81740fcc8d5
> > > 100644 --- a/drivers/net/usb/smsc75xx.c
> > > +++ b/drivers/net/usb/smsc75xx.c
> > > @@ -1504,7 +1504,10 @@ static int smsc75xx_bind(struct usbnet
> > > *dev, struct usb_interface *intf) return 0;
> > >
> > >  err:
> > > +     cancel_work_sync(&pdata->set_multicast);
> > >       kfree(pdata);
> > > +     pdata = NULL;
> > > +     dev->data[0] = 0;
> > >       return ret;
> > >  }
> > >
> >
> > Hi, Dongliang!
> >
> > Just my thougth about this patch:
> >
> > INIT_WORK(&pdata->set_multicast, smsc75xx_deferred_multicast_write);
> > does not queue anything, it just initalizes list structure and
> > assigns callback function. The actual work sheduling happens in
> > smsc75xx_set_multicast() which is smsc75xx_netdev_ops member.
> >
> 
> Yes, you are right. However, as written in the commit message,
> smsc75xx_set_multicast will be called by smsc75xx_reset [1].
> 
> If smsc75xx_set_multicast is called before any check failure occurs,
> this work(set_multicast) will be queued into the global list with
> 
> schedule_work(&pdata->set_multicast); [2]

Ah, I missed it, sorry :)

Maybe, small optimization for error handling path like:

cancel_work:
	cancel_work_sync(&pdata->set_multicast);
	dev->data[0] = 0;
free_pdata:
	kfree(pdata);
	return ret;


is suitbale here.

> 
> At last, if the pdata or dev->data[0] is freed before the
> set_multicast really executes, it may lead to a UAF. Is this correct?
> 
> BTW, even if the above is true, I don't know if I call the API
> ``cancel_work_sync(&pdata->set_multicast)'' properly if the
> schedule_work is not called.
> 

Yeah, it will be ok.

> [1]
> https://elixir.bootlin.com/linux/latest/source/drivers/net/usb/smsc75xx.c#L1322
> 
> [2]
> https://elixir.bootlin.com/linux/latest/source/drivers/net/usb/smsc75xx.c#L583
> 
> > In case of any error in smsc75xx_bind() the device registration
> > fails and smsc75xx_netdev_ops won't be registered, so, i guess,
> > there is no chance of UAF.
> >
> >
> > Am I missing something? :)
> >
> >
> >
> > With regards,
> > Pavel Skripkin




With regards,
Pavel Skripkin
