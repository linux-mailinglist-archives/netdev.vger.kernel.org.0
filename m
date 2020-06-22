Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B5B58203871
	for <lists+netdev@lfdr.de>; Mon, 22 Jun 2020 15:49:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728956AbgFVNtv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 22 Jun 2020 09:49:51 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:52230 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728070AbgFVNtu (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 22 Jun 2020 09:49:50 -0400
Received: from andrew by vps0.lunn.ch with local (Exim 4.94)
        (envelope-from <andrew@lunn.ch>)
        id 1jnMpW-001fbC-Km; Mon, 22 Jun 2020 15:49:46 +0200
Date:   Mon, 22 Jun 2020 15:49:46 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Kurt Kanzenbach <kurt@linutronix.de>
Cc:     Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        Rob Herring <robh+dt@kernel.org>, devicetree@vger.kernel.org,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        Richard Cochran <richardcochran@gmail.com>,
        Kamil Alkhouri <kamil.alkhouri@hs-offenburg.de>,
        ilias.apalodimas@linaro.org
Subject: Re: [RFC PATCH 9/9] dt-bindings: net: dsa: Add documentation for
 Hellcreek switches
Message-ID: <20200622134946.GM338481@lunn.ch>
References: <20200618064029.32168-1-kurt@linutronix.de>
 <20200618064029.32168-10-kurt@linutronix.de>
 <20200618134704.GQ249144@lunn.ch>
 <87zh8zphlc.fsf@kurt>
 <20200619135657.GF304147@lunn.ch>
 <87imfjtik4.fsf@kurt>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87imfjtik4.fsf@kurt>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Jun 22, 2020 at 02:02:19PM +0200, Kurt Kanzenbach wrote:
> On Fri Jun 19 2020, Andrew Lunn wrote:
> >> > The switch is 100/100Mbps right? The MAC is only Fast ethernet. Do you
> >> > need some properties in the port@0 node to tell the switch to only use
> >> > 100Mbps? I would expect it to default to 1G. Not looked at the code
> >> > yet...
> >> 
> >> No, that is not needed. That is a hardware configuration and AFAIK
> >> cannot be changed at run time.
> >
> > I was wondering about that in general. I did not spot any code in the
> > driver dealing with results from the PHY auto-neg. So you are saying
> > the CPU is fixed speed, by strapping? But what about the other ports?
> > Does the MAC need to know the PHY has negotiated 10Half, not 1G? Would
> > that not make a difference to your TSN?
> 
> Indeed, that does make a difference. I've checked with the vendor. The
> current version of the switch IP does not support configuring the speed
> etc. at run time. It is hard wired to 100 Mbit/s or 1000 Mbit/s for
> now. Later versions of the chip might support setting the speed etc. via
> configuration registers. As a result the PHYs at the front ports should
> be programmed to only advertise 100 Mbit/s or 1G depending on the
> hardware setup.

Hi Kurt

Are there registers which allow you to determine the strapping? There
are phylib/phylink calls you can make to set the advertisement in the
PHY. It would be good to do this in the DSA driver.

     Andrew
