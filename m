Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5125FF9129
	for <lists+netdev@lfdr.de>; Tue, 12 Nov 2019 14:57:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727337AbfKLN5P (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 12 Nov 2019 08:57:15 -0500
Received: from vps0.lunn.ch ([185.16.172.187]:35904 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727324AbfKLN5P (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 12 Nov 2019 08:57:15 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=LLceIVnPXWZv1KmyJrA5OpHI8D6HpTcyMK8+3C0Ntvc=; b=v9EHK/iSNAsx9Wmh0cF4xEmgLE
        KFLtb3kqul3U7GmVKj/PHZ7QKbGfK26yPctYQJAjW537CrwNzV6tF+d/Mdc89DXMAzGeYLWIVLcdc
        q4r1CFS0W5omSM3uYUTODwR+gu+uJKf2dcRbOh+boMQAn/MBpzKJgxtJYvQSqKiVakwE=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.92.2)
        (envelope-from <andrew@lunn.ch>)
        id 1iUWfP-0001ki-3Y; Tue, 12 Nov 2019 14:57:11 +0100
Date:   Tue, 12 Nov 2019 14:57:11 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     Vladimir Oltean <olteanv@gmail.com>
Cc:     Jakub Kicinski <jakub.kicinski@netronome.com>,
        "David S. Miller" <davem@davemloft.net>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Joergen Andreasen <joergen.andreasen@microchip.com>,
        "Allan W. Nielsen" <allan.nielsen@microchip.com>,
        Horatiu Vultur <horatiu.vultur@microchip.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        netdev <netdev@vger.kernel.org>,
        Vladimir Oltean <vladimir.oltean@nxp.com>
Subject: Re: [PATCH net-next 06/12] net: mscc: ocelot: adjust MTU on the CPU
 port in NPI mode
Message-ID: <20191112135711.GJ5090@lunn.ch>
References: <20191112124420.6225-1-olteanv@gmail.com>
 <20191112124420.6225-7-olteanv@gmail.com>
 <20191112135107.GH5090@lunn.ch>
 <CA+h21hrb9pc6q9EwjCeApQ0TmC--0s9RT31f640cQ1sxiKtUqw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+h21hrb9pc6q9EwjCeApQ0TmC--0s9RT31f640cQ1sxiKtUqw@mail.gmail.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Nov 12, 2019 at 03:52:51PM +0200, Vladimir Oltean wrote:
> On Tue, 12 Nov 2019 at 15:51, Andrew Lunn <andrew@lunn.ch> wrote:
> >
> > On Tue, Nov 12, 2019 at 02:44:14PM +0200, Vladimir Oltean wrote:
> > > From: Vladimir Oltean <vladimir.oltean@nxp.com>
> > >
> > > When using the NPI port, the DSA tag is passed through Ethernet, so the
> > > switch's MAC needs to accept it as it comes from the DSA master. Increase
> > > the MTU on the external CPU port to account for the length of the
> > > injection header.
> >
> > I think this is the only DSA driver which needs to do this. Generally,
> > the port knows it is adding/removing the extra header, and so
> > magically accepts bigger frames.
> >
> > Where i have seen issues is the other end, the host interface. It
> > sometimes drops 'full MTU' frames because the DSA header makes the
> > frame too big.
> >
> 
> No, that worked out of the box because DSA adjusts the MTU of the
> master interface by the amount of bytes specified in the overhead of
> the tagger.

Yes, i added that code, after having to modify too many MAC drivers!

     Andrew
