Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 990DF3A7DDD
	for <lists+netdev@lfdr.de>; Tue, 15 Jun 2021 14:07:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230392AbhFOMJn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 15 Jun 2021 08:09:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34794 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229983AbhFOMJm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 15 Jun 2021 08:09:42 -0400
Received: from mail-ej1-x62c.google.com (mail-ej1-x62c.google.com [IPv6:2a00:1450:4864:20::62c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 35CBBC061574;
        Tue, 15 Jun 2021 05:07:38 -0700 (PDT)
Received: by mail-ej1-x62c.google.com with SMTP id g8so22182534ejx.1;
        Tue, 15 Jun 2021 05:07:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=F2WOp7laceuxMILuVpXWmQIN4CP/UaKDpQrNGuoiets=;
        b=bpIE1xt9f4WHxc1LIBkz+TxemnxivXcZLk3PGwB9kZY3wEhtdoaHdaNGjkp0jFD8k1
         N1iud+3xq0b+kGQuusZcT2CSyTBCurvuJk3iQ1PecywAzsAAnwEzpDHqQfYUln9+Zoi0
         6RqzEA8NfkaBoMoOC+vPlk37DoBwqMlk/1m888jTNKYAB1au9ay8aouvG2bYtURbnkZI
         XCnW5XJDnlQaL4QXdOvH9KsYWG/mwwG3mMRi5kTARQfWRBO8a25rUlvHJAoa3CI6Y+yF
         8mfFFIGh05/+67prKlVF/nksi253pKlnzlwVxYW5cOG3tQ5G7u5SLvfq73fukSLKP2tP
         LGMQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=F2WOp7laceuxMILuVpXWmQIN4CP/UaKDpQrNGuoiets=;
        b=mgdkzI93KEinQ3qkKM6oUwjO5VJJtysgAA8J8u5VSMhES2fQIjDrgqGXky11cmcP0C
         /cGm52QwjCZj7WgsEt+U8q4Psza/YD7z4P2A4BRselRqcCMcjsO3SG5Ug0bZWTPVl5zA
         C56T8WNkWAQ7nhhttAtMoOtHM7uaV1wZt3ucqf47qqgWyIFDiDQpo9G2cOJ1VOPbIYyy
         FmbwHuJzI57fKsem7uaLiww98d4NXY92lhMJDxYdZMwiA5f0SCMWDLSh+bY/GA7AbHhU
         Pdq7kW5ve/SR2fzE6NKGoUXqmuHwWPedDwuXLTKyZT5ugOYWfMf8N+oZt/dLwGqhlp4z
         PUPg==
X-Gm-Message-State: AOAM531Dti6SR9C8W104FFkno90Vs5HAjDmnzJISH9vHntrw+1RklMJZ
        zEc0Q3gUJjl7dD9SH2oGCgxNwRWcxTcewYrGdBE=
X-Google-Smtp-Source: ABdhPJw1witA7P6CqSUgKjswjF/s/f7Lze23dP/muWUzifZszk/k00kEmbKiYr6L65YTPHEo+Jeuo+Kad6fWwCCm+QI=
X-Received: by 2002:a17:906:7f0e:: with SMTP id d14mr20030316ejr.103.1623758856683;
 Tue, 15 Jun 2021 05:07:36 -0700 (PDT)
MIME-Version: 1.0
References: <20210614153712.2172662-1-mudongliangabcd@gmail.com>
 <YMhY9NHf1itQyup7@kroah.com> <CAD-N9QVfDQQo0rRiaa6Cx-xO80yox9hNzK91_UVj0KNgkhpvnQ@mail.gmail.com>
 <YMh2b0LvT9H7SuNC@kroah.com> <CAD-N9QV+GMURatPx4qJT2nMsKHQhj+BXC9C-ZyQed3pN8a9YUA@mail.gmail.com>
 <CAD-N9QW6LhRO+D-rr4xCCuq+m=jtD7LS_+GDVs9DkHe5paeSOg@mail.gmail.com> <YMiLFFRfXfBHpfAF@kroah.com>
In-Reply-To: <YMiLFFRfXfBHpfAF@kroah.com>
From:   Dongliang Mu <mudongliangabcd@gmail.com>
Date:   Tue, 15 Jun 2021 20:07:10 +0800
Message-ID: <CAD-N9QUVCc8Gaw0pTqCCHMby2R4_8VNcVy+QcndoXpYe7vbt0Q@mail.gmail.com>
Subject: Re: [PATCH] net: usb: fix possible use-after-free in smsc75xx_bind
To:     Greg KH <greg@kroah.com>
Cc:     Steve Glendinning <steve.glendinning@shawell.net>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Pavel Skripkin <paskripkin@gmail.com>, netdev@vger.kernel.org,
        linux-usb@vger.kernel.org,
        linux-kernel <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jun 15, 2021 at 7:12 PM Greg KH <greg@kroah.com> wrote:
>
> On Tue, Jun 15, 2021 at 06:24:17PM +0800, Dongliang Mu wrote:
> > On Tue, Jun 15, 2021 at 6:10 PM Dongliang Mu <mudongliangabcd@gmail.com> wrote:
> > >
> > > On Tue, Jun 15, 2021 at 5:44 PM Greg KH <greg@kroah.com> wrote:
> > > >
> > > > On Tue, Jun 15, 2021 at 03:56:32PM +0800, Dongliang Mu wrote:
> > > > > On Tue, Jun 15, 2021 at 3:38 PM Greg KH <greg@kroah.com> wrote:
> > > > > >
> > > > > > On Mon, Jun 14, 2021 at 11:37:12PM +0800, Dongliang Mu wrote:
> > > > > > > The commit 46a8b29c6306 ("net: usb: fix memory leak in smsc75xx_bind")
> > > > > > > fails to clean up the work scheduled in smsc75xx_reset->
> > > > > > > smsc75xx_set_multicast, which leads to use-after-free if the work is
> > > > > > > scheduled to start after the deallocation. In addition, this patch also
> > > > > > > removes one dangling pointer - dev->data[0].
> > > > > > >
> > > > > > > This patch calls cancel_work_sync to cancel the schedule work and set
> > > > > > > the dangling pointer to NULL.
> > > > > > >
> > > > > > > Fixes: 46a8b29c6306 ("net: usb: fix memory leak in smsc75xx_bind")
> > > > > > > Signed-off-by: Dongliang Mu <mudongliangabcd@gmail.com>
> > > > > > > ---
> > > > > > >  drivers/net/usb/smsc75xx.c | 3 +++
> > > > > > >  1 file changed, 3 insertions(+)
> > > > > > >
> > > > > > > diff --git a/drivers/net/usb/smsc75xx.c b/drivers/net/usb/smsc75xx.c
> > > > > > > index b286993da67c..f81740fcc8d5 100644
> > > > > > > --- a/drivers/net/usb/smsc75xx.c
> > > > > > > +++ b/drivers/net/usb/smsc75xx.c
> > > > > > > @@ -1504,7 +1504,10 @@ static int smsc75xx_bind(struct usbnet *dev, struct usb_interface *intf)
> > > > > > >       return 0;
> > > > > > >
> > > > > > >  err:
> > > > > > > +     cancel_work_sync(&pdata->set_multicast);
> > > > > > >       kfree(pdata);
> > > > > > > +     pdata = NULL;
> > > > > >
> > > > > > Why do you have to set pdata to NULL afterward?
> > > > > >
> > > > >
> > > > > It does not have to. pdata will be useless when the function exits. I
> > > > > just referred to the implementation of smsc75xx_unbind.
> > > >
> > > > It's wrong there too :)
> > >
> > > /: I will fix such two sites in the v2 patch.
> >
> > Hi gregkh,
> >
> > If the schedule_work is not invoked, can I call
> > ``cancel_work_sync(&pdata->set_multicast)''?
>
> Why can you not call this then?

I don't know the internal of schedule_work and cancel_work_sync, so I
ask this question to confirm my patch does not introduce any new
issues.

>
> Did you try it and see?

Yes, I thought up a method and tested it in my local workspace.

First, I reproduced the memory leak in smsc75xx_bind [1] since the PoC
triggered an error before schedule_work.
Then, I merged two patches, and run the PoC. The result showed that my
patch does not trigger any new issues even the schedule_work is not
called.

[1] https://syzkaller.appspot.com/bug?id=c978ec308a1b89089a17ff48183d70b4c840dfb0

>
> thanks,
>
> greg k-h
