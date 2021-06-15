Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B39713A7CED
	for <lists+netdev@lfdr.de>; Tue, 15 Jun 2021 13:12:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230188AbhFOLOf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 15 Jun 2021 07:14:35 -0400
Received: from new1-smtp.messagingengine.com ([66.111.4.221]:60045 "EHLO
        new1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229601AbhFOLO2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 15 Jun 2021 07:14:28 -0400
Received: from compute5.internal (compute5.nyi.internal [10.202.2.45])
        by mailnew.nyi.internal (Postfix) with ESMTP id 2909B5808D9;
        Tue, 15 Jun 2021 07:12:23 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute5.internal (MEProxy); Tue, 15 Jun 2021 07:12:23 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kroah.com; h=
        date:from:to:cc:subject:message-id:references:mime-version
        :content-type:in-reply-to; s=fm1; bh=9Q6KDp2HWna3rxZivpNB7NpzF6d
        wHBZaHCxz9AOstAo=; b=VO1TcpCOxfXH3sxQowoQcl75VH48aPea2qp+QAdYfyN
        /YH7qGFT+GA1PsFaIbHL7xLq+M/t8KGQinALWSK3ocGOq3mRg6PFtGY6WXIdpXCK
        XYcx82cKdjEB2OKfrMfglX7zpcQk+M6Yu02RBEFA3pBVVd6rplPtRyLo81WlXVeb
        5Z5jf/BmyYxiCGw20t+o1P/j9IIz34aMOrOXDdDwFUHdRNnO2fB2+63ACXg4ckhh
        LdM33XMDpmcI4Qvhc/cJhTg1bR/B/ykLQ5buUUHdMCBZSPXPGuA0aq/zqxONI2yl
        Qs4VEiSKSmzs168xEtVNJ+yum1vDfvPVHr2rTak1X7g==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-type:date:from:in-reply-to
        :message-id:mime-version:references:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; bh=9Q6KDp
        2HWna3rxZivpNB7NpzF6dwHBZaHCxz9AOstAo=; b=W1FCPA7R8Q4QZWMjtIOYbO
        3essXw18DAQP9FvCgS6bIY37SDq3hNKzEpbuyM8etfT0SjPDoMbh+c0goBNMguWp
        TcEahIFdsLbm68tksyY+anScdXDmiAygPrjGQxoaAQHetdW78vEgQhmfk+qSxilQ
        5oPu+z+8zGj5BmleSskJxNuO8PMCWF1kLgqD2prfFNdax09KiI4nQ+eiw7veW/iA
        Zcd3NEWWeSydTW+qwDXQmaaz5n02y64eZaOZEHdrextyWRJCeyIuU1jmV+uLznKt
        SSPcj/0yBkyfptjxOfW49U5XRQprEO58o2J3Moo6RQC9ubBl4fqpG1dX5NP/AAZA
        ==
X-ME-Sender: <xms:FovIYHI6FQPs744CBPhrLBt-6huMUL7aRIELsQkO21C97HdZ8M5MHA>
    <xme:FovIYLJqmmf85oR2-hMw4NnOIvhESVlxgrQ-Z6OI6y5oZrHu-fBUAt-6YhQVA_E3J
    rkEwDzkrvfO9A>
X-ME-Received: <xmr:FovIYPuxE4jvdI8WJ0sTboB4yOYGp4V7F51QjwPcQS2gJGngZflDsrij7Rrv_FcDG39wuOjR7ay-HsqzkAuOzhBLUOBpOHMS>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduledrfedvjedgfeejucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmne
    cujfgurhepfffhvffukfhfgggtuggjsehttdortddttddvnecuhfhrohhmpefirhgvghcu
    mffjuceoghhrvghgsehkrhhorghhrdgtohhmqeenucggtffrrghtthgvrhhnpeevhefgje
    eitdfffefhvdegleeigeejgeeiffekieffjeeflefhieegtefhudejueenucevlhhushht
    vghrufhiiigvpedtnecurfgrrhgrmhepmhgrihhlfhhrohhmpehgrhgvgheskhhrohgrhh
    drtghomh
X-ME-Proxy: <xmx:FovIYAa2kaTzgW2gzRSBSbUWKxLRIRfIznpZ6-8HIYmpidSXLOsq2A>
    <xmx:FovIYOaoXznIKP-7V9MIKnAN_aC7b25sE_J-lROsW-2DbSZcfdcSaw>
    <xmx:FovIYEAqaAh1O_dViNm1InHclTGi435Ccz5D-ZTOyiE3lKMZdhnNtg>
    <xmx:F4vIYEy7A4CXP1uTvGbOR77Cbd5zElVCN-w1Y6xZFanI44lm-V0aiA>
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Tue,
 15 Jun 2021 07:12:22 -0400 (EDT)
Date:   Tue, 15 Jun 2021 13:12:20 +0200
From:   Greg KH <greg@kroah.com>
To:     Dongliang Mu <mudongliangabcd@gmail.com>
Cc:     Steve Glendinning <steve.glendinning@shawell.net>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Pavel Skripkin <paskripkin@gmail.com>, netdev@vger.kernel.org,
        linux-usb@vger.kernel.org,
        linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] net: usb: fix possible use-after-free in smsc75xx_bind
Message-ID: <YMiLFFRfXfBHpfAF@kroah.com>
References: <20210614153712.2172662-1-mudongliangabcd@gmail.com>
 <YMhY9NHf1itQyup7@kroah.com>
 <CAD-N9QVfDQQo0rRiaa6Cx-xO80yox9hNzK91_UVj0KNgkhpvnQ@mail.gmail.com>
 <YMh2b0LvT9H7SuNC@kroah.com>
 <CAD-N9QV+GMURatPx4qJT2nMsKHQhj+BXC9C-ZyQed3pN8a9YUA@mail.gmail.com>
 <CAD-N9QW6LhRO+D-rr4xCCuq+m=jtD7LS_+GDVs9DkHe5paeSOg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAD-N9QW6LhRO+D-rr4xCCuq+m=jtD7LS_+GDVs9DkHe5paeSOg@mail.gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jun 15, 2021 at 06:24:17PM +0800, Dongliang Mu wrote:
> On Tue, Jun 15, 2021 at 6:10 PM Dongliang Mu <mudongliangabcd@gmail.com> wrote:
> >
> > On Tue, Jun 15, 2021 at 5:44 PM Greg KH <greg@kroah.com> wrote:
> > >
> > > On Tue, Jun 15, 2021 at 03:56:32PM +0800, Dongliang Mu wrote:
> > > > On Tue, Jun 15, 2021 at 3:38 PM Greg KH <greg@kroah.com> wrote:
> > > > >
> > > > > On Mon, Jun 14, 2021 at 11:37:12PM +0800, Dongliang Mu wrote:
> > > > > > The commit 46a8b29c6306 ("net: usb: fix memory leak in smsc75xx_bind")
> > > > > > fails to clean up the work scheduled in smsc75xx_reset->
> > > > > > smsc75xx_set_multicast, which leads to use-after-free if the work is
> > > > > > scheduled to start after the deallocation. In addition, this patch also
> > > > > > removes one dangling pointer - dev->data[0].
> > > > > >
> > > > > > This patch calls cancel_work_sync to cancel the schedule work and set
> > > > > > the dangling pointer to NULL.
> > > > > >
> > > > > > Fixes: 46a8b29c6306 ("net: usb: fix memory leak in smsc75xx_bind")
> > > > > > Signed-off-by: Dongliang Mu <mudongliangabcd@gmail.com>
> > > > > > ---
> > > > > >  drivers/net/usb/smsc75xx.c | 3 +++
> > > > > >  1 file changed, 3 insertions(+)
> > > > > >
> > > > > > diff --git a/drivers/net/usb/smsc75xx.c b/drivers/net/usb/smsc75xx.c
> > > > > > index b286993da67c..f81740fcc8d5 100644
> > > > > > --- a/drivers/net/usb/smsc75xx.c
> > > > > > +++ b/drivers/net/usb/smsc75xx.c
> > > > > > @@ -1504,7 +1504,10 @@ static int smsc75xx_bind(struct usbnet *dev, struct usb_interface *intf)
> > > > > >       return 0;
> > > > > >
> > > > > >  err:
> > > > > > +     cancel_work_sync(&pdata->set_multicast);
> > > > > >       kfree(pdata);
> > > > > > +     pdata = NULL;
> > > > >
> > > > > Why do you have to set pdata to NULL afterward?
> > > > >
> > > >
> > > > It does not have to. pdata will be useless when the function exits. I
> > > > just referred to the implementation of smsc75xx_unbind.
> > >
> > > It's wrong there too :)
> >
> > /: I will fix such two sites in the v2 patch.
> 
> Hi gregkh,
> 
> If the schedule_work is not invoked, can I call
> ``cancel_work_sync(&pdata->set_multicast)''?

Why can you not call this then?

Did you try it and see?

thanks,

greg k-h
