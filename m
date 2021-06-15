Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 218743A7BB4
	for <lists+netdev@lfdr.de>; Tue, 15 Jun 2021 12:24:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231522AbhFOK0u (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 15 Jun 2021 06:26:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38318 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231220AbhFOK0t (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 15 Jun 2021 06:26:49 -0400
Received: from mail-ed1-x52d.google.com (mail-ed1-x52d.google.com [IPv6:2a00:1450:4864:20::52d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D5615C061574;
        Tue, 15 Jun 2021 03:24:44 -0700 (PDT)
Received: by mail-ed1-x52d.google.com with SMTP id r7so35944615edv.12;
        Tue, 15 Jun 2021 03:24:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=TjaB6i8KcUeUiC7lYhVxV/Olnmn95eEJM+cZhPD4C0Y=;
        b=cbnPlPiC0Rx83GFLUflqeNHgYzJEAm3xXMUb9Wz7NhfX7rwqEx4EEDIvtGaC3m3Hv0
         UNqsJP+LBT+8gm2Uq3aUB/Pfstb0PpO0i0NR7uI9cUIYMFsj30DPnFsm3sIhcQ4Guc4e
         H/T5WOaS/3tyL3daOxiCTLvL2A8Ujd6wp7p9YSXoIo5PIqKL/QpSiOUG8t7D+THq0eKp
         j14HXAzqEchVot/+2x0Eyj9WFhZIzyweTJkm8KCdSYX0L+Uc9CibfmdOQNYDWn50fHzg
         tD4QSWEFpOE3iKzwWIVVuTrgEpNtg6bDnmTt/09AI96/244D6dzx8kEsHn7ZU+m4NKhC
         Fy4w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=TjaB6i8KcUeUiC7lYhVxV/Olnmn95eEJM+cZhPD4C0Y=;
        b=ie3Oo16/J+x/YlKUTpT2cx1d94us+xY7RbMT3+Alj6jWdIJR9qZ5nsgsFFa4vnU3uX
         jYApaLvwA9D5ScM+7fRClwtkCRATaJu7mgSeUhoiOguK2UMpeBsIFWkfUi6qbXSuPZTW
         JKmWBDjdAidelYOKEeovQczW7CMR2ym9vPOniu3EiEG3s5lgSe5Yp9HtVebYUyCgjdeW
         pSnHPR+NHYU11AOWGfLQWM6HXvQUZXDCaDVLbAShVbwUuByt4Gd6BwdOXDSUYazQjMSO
         nEqW482CkpYE/gqlzS+myA2GCfRfCUmTGqgqcw2y8W6Jqr35VhL150IqELTH6CagYBq4
         /qAw==
X-Gm-Message-State: AOAM533CuUFW3x9XI/3DGqX43KIhnBTJd5CeE1yuVvAee+q8rZhhXgGH
        pU1YG1DFJsxJYdMxnxeHCs+dFy/oyOfbP8eQhnQ=
X-Google-Smtp-Source: ABdhPJzC5dkoL0r1Ed2pK8uwvcgbsL7Ji/Wrjdq+kwtKyvNu3acf7xF77SLRv8n4lhbeiD0Wey0OcT8+DmobYBCsd3I=
X-Received: by 2002:aa7:ce86:: with SMTP id y6mr22324805edv.309.1623752683473;
 Tue, 15 Jun 2021 03:24:43 -0700 (PDT)
MIME-Version: 1.0
References: <20210614153712.2172662-1-mudongliangabcd@gmail.com>
 <YMhY9NHf1itQyup7@kroah.com> <CAD-N9QVfDQQo0rRiaa6Cx-xO80yox9hNzK91_UVj0KNgkhpvnQ@mail.gmail.com>
 <YMh2b0LvT9H7SuNC@kroah.com> <CAD-N9QV+GMURatPx4qJT2nMsKHQhj+BXC9C-ZyQed3pN8a9YUA@mail.gmail.com>
In-Reply-To: <CAD-N9QV+GMURatPx4qJT2nMsKHQhj+BXC9C-ZyQed3pN8a9YUA@mail.gmail.com>
From:   Dongliang Mu <mudongliangabcd@gmail.com>
Date:   Tue, 15 Jun 2021 18:24:17 +0800
Message-ID: <CAD-N9QW6LhRO+D-rr4xCCuq+m=jtD7LS_+GDVs9DkHe5paeSOg@mail.gmail.com>
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

On Tue, Jun 15, 2021 at 6:10 PM Dongliang Mu <mudongliangabcd@gmail.com> wrote:
>
> On Tue, Jun 15, 2021 at 5:44 PM Greg KH <greg@kroah.com> wrote:
> >
> > On Tue, Jun 15, 2021 at 03:56:32PM +0800, Dongliang Mu wrote:
> > > On Tue, Jun 15, 2021 at 3:38 PM Greg KH <greg@kroah.com> wrote:
> > > >
> > > > On Mon, Jun 14, 2021 at 11:37:12PM +0800, Dongliang Mu wrote:
> > > > > The commit 46a8b29c6306 ("net: usb: fix memory leak in smsc75xx_bind")
> > > > > fails to clean up the work scheduled in smsc75xx_reset->
> > > > > smsc75xx_set_multicast, which leads to use-after-free if the work is
> > > > > scheduled to start after the deallocation. In addition, this patch also
> > > > > removes one dangling pointer - dev->data[0].
> > > > >
> > > > > This patch calls cancel_work_sync to cancel the schedule work and set
> > > > > the dangling pointer to NULL.
> > > > >
> > > > > Fixes: 46a8b29c6306 ("net: usb: fix memory leak in smsc75xx_bind")
> > > > > Signed-off-by: Dongliang Mu <mudongliangabcd@gmail.com>
> > > > > ---
> > > > >  drivers/net/usb/smsc75xx.c | 3 +++
> > > > >  1 file changed, 3 insertions(+)
> > > > >
> > > > > diff --git a/drivers/net/usb/smsc75xx.c b/drivers/net/usb/smsc75xx.c
> > > > > index b286993da67c..f81740fcc8d5 100644
> > > > > --- a/drivers/net/usb/smsc75xx.c
> > > > > +++ b/drivers/net/usb/smsc75xx.c
> > > > > @@ -1504,7 +1504,10 @@ static int smsc75xx_bind(struct usbnet *dev, struct usb_interface *intf)
> > > > >       return 0;
> > > > >
> > > > >  err:
> > > > > +     cancel_work_sync(&pdata->set_multicast);
> > > > >       kfree(pdata);
> > > > > +     pdata = NULL;
> > > >
> > > > Why do you have to set pdata to NULL afterward?
> > > >
> > >
> > > It does not have to. pdata will be useless when the function exits. I
> > > just referred to the implementation of smsc75xx_unbind.
> >
> > It's wrong there too :)
>
> /: I will fix such two sites in the v2 patch.

Hi gregkh,

If the schedule_work is not invoked, can I call
``cancel_work_sync(&pdata->set_multicast)''? If not, is there any
method to verify if the schedule_work is already called?

Best regards,
Dongliang Mu
