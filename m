Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 007D13A7AFC
	for <lists+netdev@lfdr.de>; Tue, 15 Jun 2021 11:44:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231343AbhFOJqZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 15 Jun 2021 05:46:25 -0400
Received: from new1-smtp.messagingengine.com ([66.111.4.221]:41207 "EHLO
        new1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231214AbhFOJqY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 15 Jun 2021 05:46:24 -0400
Received: from compute1.internal (compute1.nyi.internal [10.202.2.41])
        by mailnew.nyi.internal (Postfix) with ESMTP id BC6F15806F5;
        Tue, 15 Jun 2021 05:44:19 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute1.internal (MEProxy); Tue, 15 Jun 2021 05:44:19 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kroah.com; h=
        date:from:to:cc:subject:message-id:references:mime-version
        :content-type:in-reply-to; s=fm1; bh=uPRVNROLX/rJzi54lhE5A5sUE5N
        81CrRfRMujXEzKCI=; b=YIj48d/M0xtnFPhKoReFlLF2MgTT2wIjG3dCUw0POkS
        78qjGB7YTQ+QaIgDYrBR9fUM520Frbx6/6oIageDNFmAC0EU3nf1gFlOLgy5oTSr
        QGA0JSvnIFRwaaIszPRXkaVxCMYEOzpsBlKmqlCICDzSHhr53KT0rW935jFTw7hH
        PomCPG5vE9clDp+4XSumnRz+oswwZpeE8xXcBmYym7Qedt7Mk9f8KA8VGIBcyZh6
        tnrxBmiOL2xv3xM9m7DGv+Zl+VusEM0FBVHTs39CQhMT+fcP9JuYHELWTk9FvdDP
        l2h59pq6+/DyyyFpiOAsgZnFcKqdBlrR5GtpmBVyrQQ==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-type:date:from:in-reply-to
        :message-id:mime-version:references:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; bh=uPRVNR
        OLX/rJzi54lhE5A5sUE5N81CrRfRMujXEzKCI=; b=bulS1Y6BZFhLrSkfsOFFLi
        TeJ9+8VKGHf6lca+3/cbsIzdY9d/sTK9Bt4xMOVdKLCirWrnzzbPNE1AtI0V/XSH
        qiQ9nWX+kL/uLRxg0F61aw4Yr0qVvwEYBsGN0rJhSEcCNcpLYAFr66kHlR1OqBok
        kZhnsTNzwauj0GaLB5XS2tMqxdJ9AZIsOz/9JTazAIUiBogCCsn6r5kWxms0+0Z9
        oegcsu/Vq7rjVP//ENmbG/kCvq2VppGSBNtuxSjHWw3dWuqnuWtd8WUtDnKhtuU4
        ZZa4mA1etS+STeebJbZ6kEso/ADVAyH/YDXT5zJMXT+Jp8ab+JYX6Mreglaw5lTg
        ==
X-ME-Sender: <xms:c3bIYFTqrHQwspj04gDRqSjAyWj_oQR6r9vny6dmVAdBAnsWOmFFHQ>
    <xme:c3bIYOxZjS1yrHkQx0iou-su2V9XtjRE7b2p-ZfeEXbaq2iOjXnCrdh9U4RYgLgAB
    v_bxyeMV7S15w>
X-ME-Received: <xmr:c3bIYK2p6ejWeEP5NTgSSkNG3peMXahwVstfUoDy6Aj9muMNyTeY8UhbJctfya0KHnpc5vF5VnkTeo3PfqyEc-FTsYXpn3WP>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduledrfedvjedgudelucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmne
    cujfgurhepfffhvffukfhfgggtuggjsehttdertddttddvnecuhfhrohhmpefirhgvghcu
    mffjuceoghhrvghgsehkrhhorghhrdgtohhmqeenucggtffrrghtthgvrhhnpeevueehje
    fgfffgiedvudekvdektdelleelgefhleejieeugeegveeuuddukedvteenucevlhhushht
    vghrufhiiigvpedtnecurfgrrhgrmhepmhgrihhlfhhrohhmpehgrhgvgheskhhrohgrhh
    drtghomh
X-ME-Proxy: <xmx:c3bIYNAYTtAcvQJSXttGiu6dVqLKrhtvt3gP5VIDs80pUzvUCIUDvQ>
    <xmx:c3bIYOg0j1fC0EEOhfHXmuSU4Y_vJPpCunkFa4zItYx75TgZ_C49Gw>
    <xmx:c3bIYBqTSGjDin_gTjlmkeqIBDze3Ha0Mz9OsfznTNz_FmybwU0CCw>
    <xmx:c3bIYO6RN4PhSIFNLSjwZWeHo5xKXA0ryV5BDva6FJwm9QzbShJTtw>
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Tue,
 15 Jun 2021 05:44:18 -0400 (EDT)
Date:   Tue, 15 Jun 2021 11:44:15 +0200
From:   Greg KH <greg@kroah.com>
To:     Dongliang Mu <mudongliangabcd@gmail.com>
Cc:     Steve Glendinning <steve.glendinning@shawell.net>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Pavel Skripkin <paskripkin@gmail.com>, netdev@vger.kernel.org,
        linux-usb@vger.kernel.org,
        linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] net: usb: fix possible use-after-free in smsc75xx_bind
Message-ID: <YMh2b0LvT9H7SuNC@kroah.com>
References: <20210614153712.2172662-1-mudongliangabcd@gmail.com>
 <YMhY9NHf1itQyup7@kroah.com>
 <CAD-N9QVfDQQo0rRiaa6Cx-xO80yox9hNzK91_UVj0KNgkhpvnQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAD-N9QVfDQQo0rRiaa6Cx-xO80yox9hNzK91_UVj0KNgkhpvnQ@mail.gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jun 15, 2021 at 03:56:32PM +0800, Dongliang Mu wrote:
> On Tue, Jun 15, 2021 at 3:38 PM Greg KH <greg@kroah.com> wrote:
> >
> > On Mon, Jun 14, 2021 at 11:37:12PM +0800, Dongliang Mu wrote:
> > > The commit 46a8b29c6306 ("net: usb: fix memory leak in smsc75xx_bind")
> > > fails to clean up the work scheduled in smsc75xx_reset->
> > > smsc75xx_set_multicast, which leads to use-after-free if the work is
> > > scheduled to start after the deallocation. In addition, this patch also
> > > removes one dangling pointer - dev->data[0].
> > >
> > > This patch calls cancel_work_sync to cancel the schedule work and set
> > > the dangling pointer to NULL.
> > >
> > > Fixes: 46a8b29c6306 ("net: usb: fix memory leak in smsc75xx_bind")
> > > Signed-off-by: Dongliang Mu <mudongliangabcd@gmail.com>
> > > ---
> > >  drivers/net/usb/smsc75xx.c | 3 +++
> > >  1 file changed, 3 insertions(+)
> > >
> > > diff --git a/drivers/net/usb/smsc75xx.c b/drivers/net/usb/smsc75xx.c
> > > index b286993da67c..f81740fcc8d5 100644
> > > --- a/drivers/net/usb/smsc75xx.c
> > > +++ b/drivers/net/usb/smsc75xx.c
> > > @@ -1504,7 +1504,10 @@ static int smsc75xx_bind(struct usbnet *dev, struct usb_interface *intf)
> > >       return 0;
> > >
> > >  err:
> > > +     cancel_work_sync(&pdata->set_multicast);
> > >       kfree(pdata);
> > > +     pdata = NULL;
> >
> > Why do you have to set pdata to NULL afterward?
> >
> 
> It does not have to. pdata will be useless when the function exits. I
> just referred to the implementation of smsc75xx_unbind.

It's wrong there too :)
