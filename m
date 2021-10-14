Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2CAAD42D8A5
	for <lists+netdev@lfdr.de>; Thu, 14 Oct 2021 13:58:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230339AbhJNMAz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 14 Oct 2021 08:00:55 -0400
Received: from mail.kernel.org ([198.145.29.99]:57188 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230080AbhJNMAy (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 14 Oct 2021 08:00:54 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 326E960BD3;
        Thu, 14 Oct 2021 11:58:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1634212730;
        bh=Oui10MkUZm/crpdoOrZ3ozxUHKzPdQEL7AlhQ8R675Y=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=Q49C3RwqQC7F6HavHPN+uRkVi/fsecm3XXv8aXcaQZxrBVOMDR6uCdii+9bV1mEKN
         +YW4suBNflX4qGV44IqjW3FZx6O3zvmfhaV0acFTlnuTPzwf3gvXOc5w/cA4jHi+M1
         jogi6naNWIJ9Z/TQS0pBlUtwmrUH2sMNwOJb8ju7X4Z4tRefXNxA6bWO6R1TbA/GTy
         2lhyBIBfrFVKyCEEBS3NmYh1bDe3i7qBEIN4fA5UcI/eGTS3iNONGJR4QUDASH7k1a
         kJva1EYTeFratntuqWqsjs2lc6zUL1wn2azovXIEBfaY5X+B5gyX+SYUnLlgriINr0
         H1+Pxgc1EIVRA==
Date:   Thu, 14 Oct 2021 13:58:44 +0200
From:   Marek =?UTF-8?B?QmVow7pu?= <kabel@kernel.org>
To:     Alexander Dahl <ada@thorsis.com>
Cc:     Pavel Machek <pavel@ucw.cz>, devicetree@vger.kernel.org,
        linux-leds@vger.kernel.org, Andrew Lunn <andrew@lunn.ch>,
        robh+dt@kernel.org, Jacek Anaszewski <jacek.anaszewski@gmail.com>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Linus Walleij <linus.walleij@linaro.org>
Subject: Re: [PATCH 2/3] dt-bindings: leds: Add `excludes` property
Message-ID: <20211014135844.440e4e19@dellmb>
In-Reply-To: <YWgU37NQfnIOtlsn@ada.ifak-system.com>
References: <20211013204424.10961-1-kabel@kernel.org>
        <20211013204424.10961-2-kabel@kernel.org>
        <20211014102918.GA21116@duo.ucw.cz>
        <20211014124309.10b42043@dellmb>
        <YWgU37NQfnIOtlsn@ada.ifak-system.com>
X-Mailer: Claws Mail 3.18.0 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 14 Oct 2021 13:30:39 +0200
Alexander Dahl <ada@thorsis.com> wrote:

> Hei hei,
>=20
> Am Thu, Oct 14, 2021 at 12:43:09PM +0200 schrieb Marek Beh=C3=BAn:
> > On Thu, 14 Oct 2021 12:29:18 +0200
> > Pavel Machek <pavel@ucw.cz> wrote:
> >  =20
> > > Hi!
> > >  =20
> > > > Some RJ-45 connectors have LEDs wired in the following way:
> > > >=20
> > > >          LED1
> > > >       +--|>|--+
> > > >       |       |
> > > >   A---+--|<|--+---B
> > > >          LED2
> > > >=20
> > > > With + on A and - on B, LED1 is ON and LED2 is OFF. Inverting
> > > > the polarity turns LED1 OFF and LED2 ON.
> > > >=20
> > > > So these LEDs exclude each other.
> > > >=20
> > > > Add new `excludes` property to the LED binding. The property is
> > > > a phandle-array to all the other LEDs that are excluded by this
> > > > LED.   =20
> > >=20
> > > I don't think this belongs to the LED binding.
> > >=20
> > > This is controller limitation, and the driver handling the
> > > controller needs to know about it... so it does not need to learn
> > > that from the LED binding. =20
> >=20
> > It's not necessarily a controller limitation, rather a limitation of
> > the board (or ethernet connector, in the case of LEDs on an ethernet
> > connector). =20
>=20
> Such LEDs are not limited to PHYs or ethernet connectors.  There is
> hardware with such dual color LEDs connected to GPIO pins (either
> directly to the SoC or through some GPIO expander like an 74hc595
> shift register).  That mail points to such hardware:
>=20
> https://www.spinics.net/lists/linux-leds/msg11847.html
>=20
> I asked about how this can be modelled back in 2019 and it was also
> discussed last year:
>=20
> https://www.spinics.net/lists/linux-leds/msg11665.html
> https://lore.kernel.org/linux-leds/2315048.uTtSMl1LR1@ada/
>=20
> The "solution" back when I first asked was treating them as ordinary
> GPIO-LEDs and ignore the "exclusion topic" which means in practice the
> LED goes OFF if both pins are ON (high) at the same time, which works
> well enough in practice.
>=20
> > But I guess we could instead document this property in the ethernet
> > PHY controller binding for a given PHY. =20
>=20
> Because such LEDs are not restricted to ethernet PHYs, but can also be
> used with GPIOs from the hardware point of view, I would not put it
> there.
>=20
> Furthermore I would not view this as a restriction of the gpio-leds
> controller, but it's a property of the LEDs itself or the way they are
> wired to the board.
>=20
> This could (or should as Pavel suggested back in 2019) be put to a new
> driver, at least for the GPIO case, but it would need some kind of new
> binding anyways.  With that in mind I consider the proposed binding to
> be well comprehensible for a human reader/writer.
>=20
> I'm sorry, I did not have leisure time to implement such a driver yet.
> Breadboard hardware for that still waiting in the drawer. :-/

That's why I think we need the `excludes` property.

On the sw side, it should work like this:
$ cd /sys/class/leds
$ echo 1 >LED1/brightness
$ cat LED1/brightness LED2/brightness
1
0
$ echo 1 >LED2/brightness
$ cat LED1/brightness LED2/brightness
0
1

The drivers could also implement brightness_hw_changed for these LEDs.

Marek
