Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 35CC03D1BB9
	for <lists+netdev@lfdr.de>; Thu, 22 Jul 2021 04:19:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230162AbhGVBij (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 21 Jul 2021 21:38:39 -0400
Received: from mail.kernel.org ([198.145.29.99]:39900 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229916AbhGVBii (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 21 Jul 2021 21:38:38 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 7B8E961283;
        Thu, 22 Jul 2021 02:19:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1626920353;
        bh=V1UpLXYBuJU8kNTRcmsXjmKxcV/EBx8bEE5f/Iz+LxU=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=rB+w5BxlQxE6BeETej9BMBWFAQyQCXnRSHFIvPFhCmta/lBi/B/XlME8D/NVIG211
         3cXrmEMVXlHG4ZihloiVOnv+0IPyVRH2FarXFVTlbr/rKwnfViWBH/9NfBO/zkHbyw
         cZF8OKfX3ktCTqILmIC5Af8qZ3AjsnVBBmzmEepIDIFuYVtvA8qHEpTm4AJacGUkHo
         i9UrIgpzUcnE/eWVcWOR867d4IEAT2Q3zMlBj2uApRFXedJPSeYLGSTC6KqdZGre28
         TCuDq5CehTs72+BW6THG+RNcXmyni86aDctPPbKn1PXbqw3CT5BKs1jvEl5lWs8Zdg
         TCl3iZdi/AxbA==
Date:   Thu, 22 Jul 2021 04:19:08 +0200
From:   Marek =?UTF-8?B?QmVow7pu?= <kabel@kernel.org>
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     Pavel Machek <pavel@ucw.cz>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Tony Nguyen <anthony.l.nguyen@intel.com>, davem@davemloft.net,
        kuba@kernel.org, Kurt Kanzenbach <kurt@linutronix.de>,
        netdev@vger.kernel.org, sasha.neftin@intel.com,
        vitaly.lifshits@intel.com, vinicius.gomes@intel.com,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        Dvora Fuxbrumer <dvorax.fuxbrumer@linux.intel.com>,
        "linux-leds@vger.kernel.org" <linux-leds@vger.kernel.org>
Subject: Re: [PATCH net-next 5/5] igc: Export LEDs
Message-ID: <20210722041908.2f4c2937@thinkpad>
In-Reply-To: <YPjNsbjKJ/9OTaxN@lunn.ch>
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
        <YPjNsbjKJ/9OTaxN@lunn.ch>
X-Mailer: Claws Mail 3.17.8 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 22 Jul 2021 03:45:21 +0200
Andrew Lunn <andrew@lunn.ch> wrote:

> On Thu, Jul 22, 2021 at 12:45:06AM +0200, Pavel Machek wrote:
> > Hi!
> >   
> > > Also, function is totally unclear. The whole reason we want to use
> > > Linux LEDs is triggers, and it is the selected trigger which
> > > determines the function.  
> > 
> > Usually, yes. But "function" is what _manufacturer_ wanted LED to
> > mean  
> 
> So you are saying the function should be the reset default of the PHY,
> or MAC?

Pavel is talking about the manufacturer of the whole device, not just
the controller. For example on Turris Omnia there are icons over the
LEDs indicating their function. There are other devices, for example
ethernet switches, with LEDs dedicated to indicate specific things, and
these do not necessarily have to be the same as the LED controller
default.

Of course the problem is that we are not always able to determine this
from kernel. In the case of ethernet PHYs I would not create LED
classdevs unless they are defined in DTS/ACPI. In the case of igc
I am not exactly sure if the driver should register these LEDs. What if
they the manufacturer did not connected LEDs to all 3 pins, but only 1,
for example? Or used the LED pin for some other funtion, like GPIO (if
igc supports it)? Do we want to create LED classdevs for potentially
nonexistent LEDs? If yes, then I guess the function should be the reset
default.

Marek
