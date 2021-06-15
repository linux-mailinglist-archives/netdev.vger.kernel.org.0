Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 18FFB3A7E95
	for <lists+netdev@lfdr.de>; Tue, 15 Jun 2021 15:03:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230259AbhFONFM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 15 Jun 2021 09:05:12 -0400
Received: from new3-smtp.messagingengine.com ([66.111.4.229]:52869 "EHLO
        new3-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229951AbhFONFL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 15 Jun 2021 09:05:11 -0400
Received: from compute6.internal (compute6.nyi.internal [10.202.2.46])
        by mailnew.nyi.internal (Postfix) with ESMTP id 7EE21580950;
        Tue, 15 Jun 2021 09:03:06 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute6.internal (MEProxy); Tue, 15 Jun 2021 09:03:06 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kroah.com; h=
        date:from:to:cc:subject:message-id:references:mime-version
        :content-type:in-reply-to; s=fm1; bh=TEvVhDaDzPUavWveqhgjFubWZRL
        +Yd56wIK4KtGPG/Q=; b=aWscDUez2rKtKzVjYpBKUkl7PENoJoDkUpT/J9qm9in
        PJPAGjk12kb7FvCg5OlDKZD/9yWqB7UJL9Kg5eYEdUdjRoZCxKG/FeQBhr3uSYi+
        6OFiFEW7bwKnLQKLnDmseKJj6lfqIcxeTiPhcXioaJrsau9dDem3uvANn4fqJ6Ef
        AYUwgxLo3XPs6nRDRqF2ZhpHQonvSyK++EyiBsP5wpBpYIWkqbBc+Hvyq6DUeSEX
        Q8fTBmlt1qq09Hzw1FQ0pftw/rVVLbszdW4ClgCuTtZWSPDxXvEIAYJfNEIBQzXm
        y5MAA67Vs9ojThSJjgS4KnlRnf3MAjJtrs37t45b7Ng==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-type:date:from:in-reply-to
        :message-id:mime-version:references:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; bh=TEvVhD
        aDzPUavWveqhgjFubWZRL+Yd56wIK4KtGPG/Q=; b=VvvKOsyoDMrUPRQOHlb5rU
        CoTrdGNHpltSZ9vPpvIbltTSv6YM2R719n4Bak2aIsC3Sxb3XJXGh2SNy1Xj+MX7
        K03HK9DRw00YUnNbvxYjVd9QPRO4TvrmvpJXwy35PJnnpUajcPHXYwtWEu6umZRJ
        jayQPEpeccZy8mCdmgNCegz8uEvFX3uEj+0ytIs+ekyiqbSIvOxFrCjHY28IlV+3
        SqkTIWhfeUyTZctegY/1rWQxR+LIe1PGnhJEWKqeB6EGYWW57jVHJ46SNQZRfA+7
        xlRA0CHKAdnR7C0Saiw//9rDAmxnC8RbHRbRzCVVDrHfYgFlSNG3RNapAWCk6X/g
        ==
X-ME-Sender: <xms:CaXIYGWV6aan4rHF5KB-4j5bi-SXn_yxrpy5xU7jFqumPYHGr9a0wA>
    <xme:CaXIYCl2v4TOSJS0ZF4vNx4Aq4x807HSl3dR-yNaFd5sWD9uAuS68-MSOKvxrnupV
    89LBOXAdS5YCQ>
X-ME-Received: <xmr:CaXIYKZ92vw9VuSCUbnre-vgUVTxZGYlYMKuHkNRdWpYnfh2H_j7QJSAzoT-QCVgCA9q_BkG1zJEDfMqcjO1Z7fgJgCT0Vx_>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduledrfedvjedgheelucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmne
    cujfgurhepfffhvffukfhfgggtuggjsehttdertddttddvnecuhfhrohhmpefirhgvghcu
    mffjuceoghhrvghgsehkrhhorghhrdgtohhmqeenucggtffrrghtthgvrhhnpeevueehje
    fgfffgiedvudekvdektdelleelgefhleejieeugeegveeuuddukedvteenucevlhhushht
    vghrufhiiigvpedtnecurfgrrhgrmhepmhgrihhlfhhrohhmpehgrhgvgheskhhrohgrhh
    drtghomh
X-ME-Proxy: <xmx:CqXIYNUP1gNNNMjIqgXsYQrKTfqCSyC-F7fFslkbJKTjgoO6SpfkUw>
    <xmx:CqXIYAng_X4qXkxYzYjhsNb721YIzru2Yo0jIYN-flCyzuCrwrEY-Q>
    <xmx:CqXIYCcWkwCuBejGA6q3MWkFCp_OLCITqp7EPPjtFI2jpb4Lg98iww>
    <xmx:CqXIYF-c0UieXJod-q18sX2qRLInZiS6g4FcFq4vDPRrp3Q7JNLWEQ>
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Tue,
 15 Jun 2021 09:03:05 -0400 (EDT)
Date:   Tue, 15 Jun 2021 15:03:03 +0200
From:   Greg KH <greg@kroah.com>
To:     Dongliang Mu <mudongliangabcd@gmail.com>
Cc:     Steve Glendinning <steve.glendinning@shawell.net>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Pavel Skripkin <paskripkin@gmail.com>, netdev@vger.kernel.org,
        linux-usb@vger.kernel.org,
        linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] net: usb: fix possible use-after-free in smsc75xx_bind
Message-ID: <YMilB6S/eRPuc8ao@kroah.com>
References: <20210614153712.2172662-1-mudongliangabcd@gmail.com>
 <YMhY9NHf1itQyup7@kroah.com>
 <CAD-N9QVfDQQo0rRiaa6Cx-xO80yox9hNzK91_UVj0KNgkhpvnQ@mail.gmail.com>
 <YMh2b0LvT9H7SuNC@kroah.com>
 <CAD-N9QV+GMURatPx4qJT2nMsKHQhj+BXC9C-ZyQed3pN8a9YUA@mail.gmail.com>
 <CAD-N9QW6LhRO+D-rr4xCCuq+m=jtD7LS_+GDVs9DkHe5paeSOg@mail.gmail.com>
 <YMiLFFRfXfBHpfAF@kroah.com>
 <CAD-N9QUVCc8Gaw0pTqCCHMby2R4_8VNcVy+QcndoXpYe7vbt0Q@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAD-N9QUVCc8Gaw0pTqCCHMby2R4_8VNcVy+QcndoXpYe7vbt0Q@mail.gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jun 15, 2021 at 08:07:10PM +0800, Dongliang Mu wrote:
> On Tue, Jun 15, 2021 at 7:12 PM Greg KH <greg@kroah.com> wrote:
> >
> > On Tue, Jun 15, 2021 at 06:24:17PM +0800, Dongliang Mu wrote:
> > > On Tue, Jun 15, 2021 at 6:10 PM Dongliang Mu <mudongliangabcd@gmail.com> wrote:
> > > >
> > > > On Tue, Jun 15, 2021 at 5:44 PM Greg KH <greg@kroah.com> wrote:
> > > > >
> > > > > On Tue, Jun 15, 2021 at 03:56:32PM +0800, Dongliang Mu wrote:
> > > > > > On Tue, Jun 15, 2021 at 3:38 PM Greg KH <greg@kroah.com> wrote:
> > > > > > >
> > > > > > > On Mon, Jun 14, 2021 at 11:37:12PM +0800, Dongliang Mu wrote:
> > > > > > > > The commit 46a8b29c6306 ("net: usb: fix memory leak in smsc75xx_bind")
> > > > > > > > fails to clean up the work scheduled in smsc75xx_reset->
> > > > > > > > smsc75xx_set_multicast, which leads to use-after-free if the work is
> > > > > > > > scheduled to start after the deallocation. In addition, this patch also
> > > > > > > > removes one dangling pointer - dev->data[0].
> > > > > > > >
> > > > > > > > This patch calls cancel_work_sync to cancel the schedule work and set
> > > > > > > > the dangling pointer to NULL.
> > > > > > > >
> > > > > > > > Fixes: 46a8b29c6306 ("net: usb: fix memory leak in smsc75xx_bind")
> > > > > > > > Signed-off-by: Dongliang Mu <mudongliangabcd@gmail.com>
> > > > > > > > ---
> > > > > > > >  drivers/net/usb/smsc75xx.c | 3 +++
> > > > > > > >  1 file changed, 3 insertions(+)
> > > > > > > >
> > > > > > > > diff --git a/drivers/net/usb/smsc75xx.c b/drivers/net/usb/smsc75xx.c
> > > > > > > > index b286993da67c..f81740fcc8d5 100644
> > > > > > > > --- a/drivers/net/usb/smsc75xx.c
> > > > > > > > +++ b/drivers/net/usb/smsc75xx.c
> > > > > > > > @@ -1504,7 +1504,10 @@ static int smsc75xx_bind(struct usbnet *dev, struct usb_interface *intf)
> > > > > > > >       return 0;
> > > > > > > >
> > > > > > > >  err:
> > > > > > > > +     cancel_work_sync(&pdata->set_multicast);
> > > > > > > >       kfree(pdata);
> > > > > > > > +     pdata = NULL;
> > > > > > >
> > > > > > > Why do you have to set pdata to NULL afterward?
> > > > > > >
> > > > > >
> > > > > > It does not have to. pdata will be useless when the function exits. I
> > > > > > just referred to the implementation of smsc75xx_unbind.
> > > > >
> > > > > It's wrong there too :)
> > > >
> > > > /: I will fix such two sites in the v2 patch.
> > >
> > > Hi gregkh,
> > >
> > > If the schedule_work is not invoked, can I call
> > > ``cancel_work_sync(&pdata->set_multicast)''?
> >
> > Why can you not call this then?
> 
> I don't know the internal of schedule_work and cancel_work_sync, so I
> ask this question to confirm my patch does not introduce any new
> issues.

Please see the documentation for this function for all of the details.
It is in kernel/workqueue.c

