Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 06C0D42D84A
	for <lists+netdev@lfdr.de>; Thu, 14 Oct 2021 13:36:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231159AbhJNLiL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 14 Oct 2021 07:38:11 -0400
Received: from mail.thorsis.com ([92.198.35.195]:44701 "EHLO mail.thorsis.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229984AbhJNLiK (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 14 Oct 2021 07:38:10 -0400
X-Greylist: delayed 310 seconds by postgrey-1.27 at vger.kernel.org; Thu, 14 Oct 2021 07:38:09 EDT
Received: from localhost (localhost [127.0.0.1])
        by mail.thorsis.com (Postfix) with ESMTP id 28F38DF2;
        Thu, 14 Oct 2021 13:30:53 +0200 (CEST)
X-Virus-Scanned: Debian amavisd-new at mail.thorsis.com
Received: from mail.thorsis.com ([127.0.0.1])
        by localhost (mail.thorsis.com [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id FKW-dOaehEgS; Thu, 14 Oct 2021 13:30:53 +0200 (CEST)
Received: by mail.thorsis.com (Postfix, from userid 109)
        id 3B27824F9; Thu, 14 Oct 2021 13:30:50 +0200 (CEST)
X-Spam-Level: 
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,NO_RECEIVED,
        NO_RELAYS,URIBL_BLOCKED autolearn=unavailable autolearn_force=no
        version=3.4.2
X-Spam-Report: * -1.9 BAYES_00 BODY: Bayes spam probability is 0 to 1%
        *      [score: 0.0000]
        * -0.0 NO_RELAYS Informational: message was not relayed via SMTP
        *  0.0 URIBL_BLOCKED ADMINISTRATOR NOTICE: The query to URIBL was
        *      blocked.  See
        *      http://wiki.apache.org/spamassassin/DnsBlocklists#dnsbl-block
        *      for more information.
        *      [URIs: spinics.net]
        * -0.0 NO_RECEIVED Informational: message has no Received headers
Date:   Thu, 14 Oct 2021 13:30:39 +0200
From:   Alexander Dahl <ada@thorsis.com>
To:     Marek =?iso-8859-1?Q?Beh=FAn?= <kabel@kernel.org>
Cc:     Pavel Machek <pavel@ucw.cz>, devicetree@vger.kernel.org,
        linux-leds@vger.kernel.org, Andrew Lunn <andrew@lunn.ch>,
        robh+dt@kernel.org, Jacek Anaszewski <jacek.anaszewski@gmail.com>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Linus Walleij <linus.walleij@linaro.org>
Subject: Re: [PATCH 2/3] dt-bindings: leds: Add `excludes` property
Message-ID: <YWgU37NQfnIOtlsn@ada.ifak-system.com>
Mail-Followup-To: Marek =?iso-8859-1?Q?Beh=FAn?= <kabel@kernel.org>,
        Pavel Machek <pavel@ucw.cz>, devicetree@vger.kernel.org,
        linux-leds@vger.kernel.org, Andrew Lunn <andrew@lunn.ch>,
        robh+dt@kernel.org, Jacek Anaszewski <jacek.anaszewski@gmail.com>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Linus Walleij <linus.walleij@linaro.org>
References: <20211013204424.10961-1-kabel@kernel.org>
 <20211013204424.10961-2-kabel@kernel.org>
 <20211014102918.GA21116@duo.ucw.cz>
 <20211014124309.10b42043@dellmb>
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20211014124309.10b42043@dellmb>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hei hei,

Am Thu, Oct 14, 2021 at 12:43:09PM +0200 schrieb Marek Behún:
> On Thu, 14 Oct 2021 12:29:18 +0200
> Pavel Machek <pavel@ucw.cz> wrote:
> 
> > Hi!
> > 
> > > Some RJ-45 connectors have LEDs wired in the following way:
> > > 
> > >          LED1
> > >       +--|>|--+
> > >       |       |
> > >   A---+--|<|--+---B
> > >          LED2
> > > 
> > > With + on A and - on B, LED1 is ON and LED2 is OFF. Inverting the
> > > polarity turns LED1 OFF and LED2 ON.
> > > 
> > > So these LEDs exclude each other.
> > > 
> > > Add new `excludes` property to the LED binding. The property is a
> > > phandle-array to all the other LEDs that are excluded by this LED.  
> > 
> > I don't think this belongs to the LED binding.
> > 
> > This is controller limitation, and the driver handling the controller
> > needs to know about it... so it does not need to learn that from the
> > LED binding.
> 
> It's not necessarily a controller limitation, rather a limitation of
> the board (or ethernet connector, in the case of LEDs on an ethernet
> connector).

Such LEDs are not limited to PHYs or ethernet connectors.  There is
hardware with such dual color LEDs connected to GPIO pins (either
directly to the SoC or through some GPIO expander like an 74hc595
shift register).  That mail points to such hardware:

https://www.spinics.net/lists/linux-leds/msg11847.html

I asked about how this can be modelled back in 2019 and it was also
discussed last year:

https://www.spinics.net/lists/linux-leds/msg11665.html
https://lore.kernel.org/linux-leds/2315048.uTtSMl1LR1@ada/

The "solution" back when I first asked was treating them as ordinary
GPIO-LEDs and ignore the "exclusion topic" which means in practice the
LED goes OFF if both pins are ON (high) at the same time, which works
well enough in practice.

> But I guess we could instead document this property in the ethernet PHY
> controller binding for a given PHY.

Because such LEDs are not restricted to ethernet PHYs, but can also be
used with GPIOs from the hardware point of view, I would not put it
there.

Furthermore I would not view this as a restriction of the gpio-leds
controller, but it's a property of the LEDs itself or the way they are
wired to the board.

This could (or should as Pavel suggested back in 2019) be put to a new
driver, at least for the GPIO case, but it would need some kind of new
binding anyways.  With that in mind I consider the proposed binding to
be well comprehensible for a human reader/writer.

I'm sorry, I did not have leisure time to implement such a driver yet.
Breadboard hardware for that still waiting in the drawer. :-/

Greets
Alex

