Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 37DD327634A
	for <lists+netdev@lfdr.de>; Wed, 23 Sep 2020 23:46:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726419AbgIWVqu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 23 Sep 2020 17:46:50 -0400
Received: from esa5.microchip.iphmx.com ([216.71.150.166]:64233 "EHLO
        esa5.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726134AbgIWVqu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 23 Sep 2020 17:46:50 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1600897609; x=1632433609;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=UyfD7Jrzep6HyqhO7pLYY6Aj9sBMzZU65uJmTANGRAc=;
  b=nwyjzdFe5lBlVBMvcOX0EYVmreeXI8FWBtnVyW+OZQIsRw8MyGhx5Gp7
   ah2JKr720kBbpFS5JPv0IKwXkgSWX9mWlaymhLR1Kra8HTyfXqPOoJsZG
   FQhn+mpJU8XYWulwi3vpOv8jmb21sxbFy1+gsYx0ch9Z8yRmMwKVgeF7L
   cl7JWu30ga32RNq3CH5qdnpTRT2vkdMo8Z9m84eEsKKAda5EeDvYFH8Ul
   W6RmAJ1v6ZCNqHTAO67tIm6kFBYzRsIvRszrTH7JB0NDryZfwDPxJXE1V
   Okxy6YGTSF3NfNA/dZZTa8j/yiOB3t8EbNhKZq+DbWgAy03fu1NeLhqqy
   w==;
IronPort-SDR: iKX8fCXTKno6DPvVI+0XNAr3DQcBln+ViKdB3Lw32hoE9iOehzhigQLCsUprYbn2XytouVQm5I
 Jb7IgRcd8QDR3S4Qly84rjft06ZJBwQjWxACy64xPRvX4zwAKzKCwWAeMfjipXiE5rY5EKkiY+
 fX9GEVv00L4/IiEdu/FjvhV+PNd9RelXLiPiPmuVXsttbcMwfD48hUH3KaCWe6lMYOfloW7I6p
 410pyK8gv4303ke1nSkWeDoP4J5zI9Xaw7Vp56ysnRUeATWmPZ79wP377cEr2iKcWkZXn2IIpI
 500=
X-IronPort-AV: E=Sophos;i="5.77,295,1596524400"; 
   d="scan'208";a="92142947"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa5.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 23 Sep 2020 14:46:49 -0700
Received: from chn-vm-ex03.mchp-main.com (10.10.85.151) by
 chn-vm-ex01.mchp-main.com (10.10.85.143) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Wed, 23 Sep 2020 14:46:28 -0700
Received: from localhost (10.10.115.15) by chn-vm-ex03.mchp-main.com
 (10.10.85.151) with Microsoft SMTP Server id 15.1.1979.3 via Frontend
 Transport; Wed, 23 Sep 2020 14:46:48 -0700
Date:   Wed, 23 Sep 2020 23:46:47 +0200
From:   Horatiu Vultur <horatiu.vultur@microchip.com>
To:     Vladimir Oltean <vladimir.oltean@nxp.com>
CC:     "davem@davemloft.net" <davem@davemloft.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "Y.b. Lu" <yangbo.lu@nxp.com>,
        Xiaoliang Yang <xiaoliang.yang_1@nxp.com>,
        "UNGLinuxDriver@microchip.com" <UNGLinuxDriver@microchip.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        "alexandre.belloni@bootlin.com" <alexandre.belloni@bootlin.com>,
        "andrew@lunn.ch" <andrew@lunn.ch>,
        "vivien.didelot@gmail.com" <vivien.didelot@gmail.com>,
        "f.fainelli@gmail.com" <f.fainelli@gmail.com>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "richardcochran@gmail.com" <richardcochran@gmail.com>
Subject: Re: [PATCH net-next] net: mscc: ocelot: always pass skb clone to
 ocelot_port_add_txtstamp_skb
Message-ID: <20200923214647.pdsymgavxyl5dixm@soft-dev3.localdomain>
References: <20200923112420.2147806-1-vladimir.oltean@nxp.com>
 <20200923200800.t7y47fagvgffw4ya@soft-dev3.localdomain>
 <20200923202231.vr5ll2yu4gztqzwj@skbuf>
 <20200923203530.lenv5jedwmtefwqu@soft-dev3.localdomain>
 <20200923204548.k2f44gjl7s4dwoim@skbuf>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Disposition: inline
In-Reply-To: <20200923204548.k2f44gjl7s4dwoim@skbuf>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The 09/23/2020 20:45, Vladimir Oltean wrote:
> 
> On Wed, Sep 23, 2020 at 10:35:30PM +0200, Horatiu Vultur wrote:
> > The 09/23/2020 20:22, Vladimir Oltean wrote:
> > > On Wed, Sep 23, 2020 at 10:08:00PM +0200, Horatiu Vultur wrote:
> > > > The 09/23/2020 14:24, Vladimir Oltean wrote:
> > > > > +               if (ocelot_port->ptp_cmd == IFH_REW_OP_TWO_STEP_PTP) {
> > > > > +                       struct sk_buff *clone;
> > > > > +
> > > > > +                       clone = skb_clone_sk(skb);
> > > > > +                       if (!clone) {
> > > > > +                               kfree_skb(skb);
> > > > > +                               return NETDEV_TX_OK;
> > > >
> > > > Why do you return NETDEV_TX_OK?
> > > > Because the frame is not sent yet.
> > >
> > > I suppose I _could_ increment the tx_dropped counters, if that's what
> > > you mean.
> >
> > Yeah, something like that I was thinking.
> >
> > Also I am just thinking, not sure if it is correct but, can you return
> > NETDEV_TX_BUSY and not free the skb?
> >
> 
> Do you have a use case for NETDEV_TX_BUSY instead of plain dropping the
> skb, some situation where it would be better?

Not really.

> 
> I admit I haven't tested this particular code path, but my intuition
> tells me that under OOM, the last thing you need is some networking
> driver just trying and trying again to send a packet.

Yes, I totally understand your point and I aggree with you.

> 
> Documentation/networking/driver.rst:

I looked also initially in this document, that is the reason why I was
not sure if it is correct to return NETDEV_TX_BUSY.

> 
> 1) The ndo_start_xmit method must not return NETDEV_TX_BUSY under
>    any normal circumstances.  It is considered a hard error unless
>    there is no way your device can tell ahead of time when it's
>    transmit function will become busy.
> 
> Looking up the uses of NETDEV_TX_BUSY, I see pretty much only congestion
> type of events.
> 
> Thanks,
> -Vladimir

-- 
/Horatiu
