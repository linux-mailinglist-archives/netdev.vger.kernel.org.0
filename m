Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 001A53D1B81
	for <lists+netdev@lfdr.de>; Thu, 22 Jul 2021 03:45:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230135AbhGVBFR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 21 Jul 2021 21:05:17 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:39446 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229868AbhGVBFR (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 21 Jul 2021 21:05:17 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=jci+fyw9lSVyOjtUjEqX4zk7l57C+QNXNVV6CUJAG8E=; b=cqPC7WcGw2V6Igo6AYgJlpvZVX
        EApsC3gVTeRLvhQOX3f/gyauTJ5+lZhYHNMTEE1b/hREM0pRrq9tdwxwGS3yumH36JXSTUVU/bap4
        kJS3iABDeGNXa1DEq4Z1lKC6LALDrqa3Ffss/3qSUQXpcBqiMYL7PiRKtKPdZpPkNt10=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1m6Nm5-00EH9c-HY; Thu, 22 Jul 2021 03:45:21 +0200
Date:   Thu, 22 Jul 2021 03:45:21 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Pavel Machek <pavel@ucw.cz>
Cc:     Marek =?iso-8859-1?Q?Beh=FAn?= <kabel@kernel.org>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Tony Nguyen <anthony.l.nguyen@intel.com>, davem@davemloft.net,
        kuba@kernel.org, Kurt Kanzenbach <kurt@linutronix.de>,
        netdev@vger.kernel.org, sasha.neftin@intel.com,
        vitaly.lifshits@intel.com, vinicius.gomes@intel.com,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        Dvora Fuxbrumer <dvorax.fuxbrumer@linux.intel.com>,
        "linux-leds@vger.kernel.org" <linux-leds@vger.kernel.org>
Subject: Re: [PATCH net-next 5/5] igc: Export LEDs
Message-ID: <YPjNsbjKJ/9OTaxN@lunn.ch>
References: <f705bcd6-c55c-0b07-612f-38348d85bbee@gmail.com>
 <YPTKB0HGEtsydf9/@lunn.ch>
 <88d23db8-d2d2-5816-6ba1-3bd80738c398@gmail.com>
 <YPbu8xOFDRZWMTBe@lunn.ch>
 <3b7ad100-643e-c173-0d43-52e65d41c8c3@gmail.com>
 <20210721204543.08e79fac@thinkpad>
 <YPh6b+dTZqQNX+Zk@lunn.ch>
 <20210721220716.539f780e@thinkpad>
 <YPiJjEBV1PZQu0S/@lunn.ch>
 <20210721224506.GB7278@duo.ucw.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210721224506.GB7278@duo.ucw.cz>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Jul 22, 2021 at 12:45:06AM +0200, Pavel Machek wrote:
> Hi!
> 
> > Also, function is totally unclear. The whole reason we want to use
> > Linux LEDs is triggers, and it is the selected trigger which
> > determines the function.
> 
> Usually, yes. But "function" is what _manufacturer_ wanted LED to
> mean

So you are saying the function should be the reset default of the PHY,
or MAC?

> > Colour is also an issue. The IGC Ethernet controller has no idea what
> > colour the LEDs are in the RG-45 socket. And this is generic to
> > Ethernet MAC and PHY chips. The data sheets never mention colour.
> 
> Maybe datasheet does not mention color, but the LED _has_ color.

Sure it does, but the driver is for the LED controller, not the
LED. The controller does not care what colour the LED is. At least for
this application.

> > might know the colour in DT (and maybe ACPI) systems where you have
> > specific information about the board. But in for PCIe card, USB
> > dongles, etc, colour is unknown.
> 
> Not.. really. You don't know from chip specificiations, but you should
> know the color as soon as you have USB IDs (because they should tell
> you exact hardware).

No. All it tells you is what the controller is. The dongle manufacture
can pair any RJ-45 socket with the controller, and it is the RJ-45
socket which provides the LED.

> And I believe same is true for PCIe cards.

Also not true. The PCIe IDs tell you the controller. What RJ-45 socket
is connected is up to the board manufacture.

> Anyway, you can leave the color field empty if you don't know.

That is the more likely case.

     Andrew
