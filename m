Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C1D923CCB52
	for <lists+netdev@lfdr.de>; Mon, 19 Jul 2021 00:34:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232724AbhGRWgy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 18 Jul 2021 18:36:54 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:32934 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229585AbhGRWgv (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 18 Jul 2021 18:36:51 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=ayhWRsSlF7QKCWEVGjS1pgeLkcfIT3hF0BxjwsBDYXg=; b=r+3K+R1Sh4bofVnfvDbNvpYGuW
        S640NDtmdDe/c6Mev6Mh5j9x0dZSMz1T4jrkLAKT+Rku0pUmD6mGF91i01erqoQxfY0/DRbJWN++A
        zs7V9ksOU3F6RY1kfzBCkoR+irrt7goKn1XZjjWgMqz1U9xqiKwXeXnxM4VgAXecOwVE=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1m5FM0-00DpcA-L2; Mon, 19 Jul 2021 00:33:44 +0200
Date:   Mon, 19 Jul 2021 00:33:44 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Heiner Kallweit <hkallweit1@gmail.com>
Cc:     Tony Nguyen <anthony.l.nguyen@intel.com>,
        Kurt Kanzenbach <kurt@linutronix.de>, davem@davemloft.net,
        kuba@kernel.org, netdev@vger.kernel.org, sasha.neftin@intel.com,
        vitaly.lifshits@intel.com, vinicius.gomes@intel.com,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        Dvora Fuxbrumer <dvorax.fuxbrumer@linux.intel.com>
Subject: Re: [PATCH net-next 5/5] igc: Export LEDs
Message-ID: <YPSsSL32QNBnx0xc@lunn.ch>
References: <20210716212427.821834-1-anthony.l.nguyen@intel.com>
 <20210716212427.821834-6-anthony.l.nguyen@intel.com>
 <YPIAnq6r3KgQ5ivI@lunn.ch>
 <f42099b8-5ba3-3514-e5fa-8d1be37192b5@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <f42099b8-5ba3-3514-e5fa-8d1be37192b5@gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Jul 19, 2021 at 12:10:52AM +0200, Heiner Kallweit wrote:
> On 16.07.2021 23:56, Andrew Lunn wrote:
> > On Fri, Jul 16, 2021 at 02:24:27PM -0700, Tony Nguyen wrote:
> >> From: Kurt Kanzenbach <kurt@linutronix.de>
> >>
> >> Each i225 has three LEDs. Export them via the LED class framework.
> >>
> >> Each LED is controllable via sysfs. Example:
> >>
> >> $ cd /sys/class/leds/igc_led0
> >> $ cat brightness      # Current Mode
> >> $ cat max_brightness  # 15
> >> $ echo 0 > brightness # Mode 0
> >> $ echo 1 > brightness # Mode 1
> >>
> >> The brightness field here reflects the different LED modes ranging
> >> from 0 to 15.
> > 
> > What do you mean by mode? Do you mean blink mode? Like On means 1G
> > link, and it blinks for packet TX?
> > 
> Supposedly mode refers to a 4-bit bitfield in a LED control register
> where each value 0 .. 15 stands for a different blink mode.
> So you would need the datasheet to know which value to set.

If the brightness is being abused to represent the blink mode, this
patch is going to get my NACK. Unfortunately, i cannot find a
datasheet for this chip to know what the LED control register actually
does. So i'm waiting for a reply to my question.

There is a broad agreement between the LED maintainers and the PHYLIB
maintainers how Ethernet LEDs should be described with the hardware
blinking the LED for different reasons. The LED trigger mechanisms
should be used, one trigger per mode, and the trigger is then
offloaded to the hardware.

	  Andrew
