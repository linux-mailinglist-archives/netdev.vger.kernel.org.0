Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3996A41CFAC
	for <lists+netdev@lfdr.de>; Thu, 30 Sep 2021 01:05:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347378AbhI2XGs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 29 Sep 2021 19:06:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49964 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346558AbhI2XGr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 29 Sep 2021 19:06:47 -0400
Received: from mail-ed1-x530.google.com (mail-ed1-x530.google.com [IPv6:2a00:1450:4864:20::530])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 91493C06161C;
        Wed, 29 Sep 2021 16:05:05 -0700 (PDT)
Received: by mail-ed1-x530.google.com with SMTP id dj4so15038180edb.5;
        Wed, 29 Sep 2021 16:05:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=junDmjsGeeXH6AFTkfwWvE4eRp4hhF7+aaNBz6qBSf8=;
        b=nh+yG0zcGzynV4sBXDmkkmzICeb9RD15jcVuXjresYcIPWYL58XSbBQJPKfFUhr8HZ
         MK4Ib2UM8QwPkWwPxTMaRQEZ7gbfZVkjY7R55PfgC8cA3vxaGIuubZfMiyj9VlQerY0G
         qzd51mNwVvGn5OlKaSz/Lja0vXV7+4AkM9gTHuvhGWaH7j6tX0+l7bCARq1tzxrntQrq
         CvBE28bSBCl3RlT5j8Yqj/eKQpRAQ+yYCXcXk9WsLzhOo96mtf6lFIu/3zDEbovoQwEZ
         tHt6Xf2OqFLnM2+N8UUPKz225lJqSVJC5Yg9eYivz/QUcj3aj93WFOKT1cDCHpAZRDjK
         QYuA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=junDmjsGeeXH6AFTkfwWvE4eRp4hhF7+aaNBz6qBSf8=;
        b=ZtSl/1Sm/JR0t5EAx9QBq+dByZq+MnrmyQjys82YA2zDCV0vt2ZpqHHeqsBl7Wq8L2
         uaw7GF2xykuTiKrs7TUnprSH2up67FV+IUKoYIZ21XMFUN7O7Okltwljw9JgEYTjlNzj
         kUSkqc24yzcJUYigxVtc9sXdbWDcnwYnjDqk6nDmRNG/8g4q8g4zIHjlnMQC1QBlPSjl
         aUaDZPIgiFA5P8SOY543jXYP1sf+P2nOo7AQoP9Aoh8ohr7yeZqbZDCnKgtd3w7XCUOA
         xSxFvnPkyoFAtjSiPZg6LMqg9epNITs5UJYQ9dMDbC8gnRr02Vlr6HI9caUH0y0F75Ng
         n9Sw==
X-Gm-Message-State: AOAM530Sunscs256hAStMS7pUgb+m5LoQ0lF7UFsWmUafG9g3oV9A7ZW
        ZjR9wjlfeuPZdJCMoEJfLn7wT6s2MvyoYIBsnq4=
X-Google-Smtp-Source: ABdhPJxNd8W4XXeXlRU3CKfDahGD6/F3XW55XhcqTgBtosY67UqcxtnkEDtJXvkNIg6AA+Ojjixpjh5S39+glLbrxjQ=
X-Received: by 2002:a05:6402:513:: with SMTP id m19mr1037540edv.184.1632956703972;
 Wed, 29 Sep 2021 16:05:03 -0700 (PDT)
MIME-Version: 1.0
References: <1632519891-26510-1-git-send-email-justinpopo6@gmail.com>
 <1632519891-26510-4-git-send-email-justinpopo6@gmail.com> <YU9SHpn4ZJrjqNuF@lunn.ch>
 <c66c8bd1-940a-bf9d-ce33-5a39635e9f5b@gmail.com> <YVB8ef3aMpJTEvgF@lunn.ch>
In-Reply-To: <YVB8ef3aMpJTEvgF@lunn.ch>
From:   Justin Chen <justinpopo6@gmail.com>
Date:   Wed, 29 Sep 2021 16:04:53 -0700
Message-ID: <CAJx26kVw8iJD_wJXypF4gjx697z_ErOdogWNNQffis19pt6y_w@mail.gmail.com>
Subject: Re: [PATCH net-next 3/5] net: bcmasp: Add support for ASP2.0 Ethernet controller
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     Florian Fainelli <f.fainelli@gmail.com>, netdev@vger.kernel.org,
        bcm-kernel-feedback-list <bcm-kernel-feedback-list@broadcom.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Rob Herring <robh+dt@kernel.org>,
        Doug Berger <opendmb@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        Sumit Semwal <sumit.semwal@linaro.org>,
        =?UTF-8?Q?Christian_K=C3=B6nig?= <christian.koenig@amd.com>,
        =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <rafal@milecki.pl>,
        Randy Dunlap <rdunlap@infradead.org>,
        Arnd Bergmann <arnd@arndb.de>,
        Michael Chan <michael.chan@broadcom.com>,
        Geert Uytterhoeven <geert+renesas@glider.be>,
        "open list:OPEN FIRMWARE AND FLATTENED DEVICE TREE BINDINGS" 
        <devicetree@vger.kernel.org>,
        open list <linux-kernel@vger.kernel.org>,
        "open list:DMA BUFFER SHARING FRAMEWORK" 
        <linux-media@vger.kernel.org>,
        "open list:DMA BUFFER SHARING FRAMEWORK" 
        <dri-devel@lists.freedesktop.org>,
        "moderated list:DMA BUFFER SHARING FRAMEWORK" 
        <linaro-mm-sig@lists.linaro.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Sep 26, 2021 at 6:58 AM Andrew Lunn <andrew@lunn.ch> wrote:
>
> > > > +static int bcmasp_set_priv_flags(struct net_device *dev, u32 flags)
> > > > +{
> > > > + struct bcmasp_intf *intf = netdev_priv(dev);
> > > > +
> > > > + intf->wol_keep_rx_en = flags & BCMASP_WOL_KEEP_RX_EN ? 1 : 0;
> > > > +
> > > > + return 0;
> > >
> > > Please could you explain this some more. How can you disable RX and
> > > still have WoL working?
> >
> > Wake-on-LAN using Magic Packets and network filters requires keeping the
> > UniMAC's receiver turned on, and then the packets feed into the Magic Packet
> > Detector (MPD) block or the network filter block. In that mode DRAM is in
> > self refresh and there is local matching of frames into a tiny FIFO however
> > in the case of magic packets the packets leading to a wake-up are dropped as
> > there is nowhere to store them. In the case of a network filter match (e.g.:
> > matching a multicast IP address plus protocol, plus source/destination
> > ports) the packets are also discarded because the receive DMA was shut down.
> >
> > When the wol_keep_rx_en flag is set, the above happens but we also allow the
> > packets that did match a network filter to reach the small FIFO (Justin
> > would know how many entries are there) that is used to push the packets to
> > DRAM. The packet contents are held in there until the system wakes up which
> > is usually just a few hundreds of micro seconds after we received a packet
> > that triggered a wake-up. Once we overflow the receive DMA FIFO capacity
> > subsequent packets get dropped which is fine since we are usually talking
> > about very low bit rates, and we only try to push to DRAM the packets of
> > interest, that is those for which we have a network filter.
> >
> > This is convenient in scenarios where you want to wake-up from multicast DNS
> > (e.g.: wake on Googlecast, Bonjour etc.) because then the packet that
> > resulted in the system wake-up is not discarded but is then delivered to the
> > network stack.
>
> Thanks for the explanation. It would be easier for the user if you
> automate this. Enable is by default for WoL types which have user
> content?
>
Yup that can work. We can enable it for WAKE_FILTER type wol and leave
it disabled otherwise.

> > > > + /* Per ch */
> > > > + intf->tx_spb_dma = priv->base + TX_SPB_DMA_OFFSET(intf);
> > > > + intf->res.tx_spb_ctrl = priv->base + TX_SPB_CTRL_OFFSET(intf);
> > > > + /*
> > > > +  * Stop gap solution. This should be removed when 72165a0 is
> > > > +  * deprecated
> > > > +  */
> > >
> > > Is that an internal commit?
> >
> > Yes this is a revision of the silicon that is not meant to see the light of
> > day.
>
> So this can all be removed?
>
Yup. That can be removed

>    Andrew

Thanks for the review.

Justin
