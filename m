Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D914F4231F5
	for <lists+netdev@lfdr.de>; Tue,  5 Oct 2021 22:27:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236296AbhJEU24 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 5 Oct 2021 16:28:56 -0400
Received: from mail.kernel.org ([198.145.29.99]:51880 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229805AbhJEU2x (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 5 Oct 2021 16:28:53 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 33A2960E94;
        Tue,  5 Oct 2021 20:27:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1633465622;
        bh=Fe8hRws+HYAn+yuEeUxNPxPV1kFCsJKrYkmisvLPhM4=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=pI3hQuVIzzIjGmLk2T4FXBivGfJ1TN0HoWuQzzgIWmBCN7NSfQuY8iwyqLWyM7w23
         pBRFAzAsXlV7yEpCQCJ3voB7Dfl5K8J2iG5E6VaarXbbFxLyrzJqcBkN6EfCmDE0Pq
         7iXpJxB+YcJbksLqTTazWla+AN8UN60K3oXA5Xp4MOBPmwGJxDs1HkBM21mEDt2u1Z
         0w3lYveRT8yCm2STO/zpHWM9RMxNLkLizFARavDnPFCeqgMY+sha9UDGXSVGqWEkxa
         J4DgX7pi8npYeZn+TQ0zKDdzBbgB5BROCvtXhZn/0rFzZTPePWiOu/YMqN6uLjP7qc
         AzwCXrP4WFU8Q==
Date:   Tue, 5 Oct 2021 22:26:57 +0200
From:   Marek =?UTF-8?B?QmVow7pu?= <kabel@kernel.org>
To:     Jacek Anaszewski <jacek.anaszewski@gmail.com>
Cc:     Andrew Lunn <andrew@lunn.ch>, Rob Herring <robh+dt@kernel.org>,
        Pavel Machek <pavel@ucw.cz>,
        "linux-leds@vger.kernel.org" <linux-leds@vger.kernel.org>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        devicetree@vger.kernel.org
Subject: Re: lets settle the LED `function` property regarding the netdev
 trigger
Message-ID: <20211005222657.7d1b2a19@thinkpad>
In-Reply-To: <0b1bc2d7-6e62-5adb-5aed-48b99770d80d@gmail.com>
References: <20211001143601.5f57eb1a@thinkpad>
        <YVn815h7JBtVSfwZ@lunn.ch>
        <20211003212654.30fa43f5@thinkpad>
        <YVsUodiPoiIESrEE@lunn.ch>
        <20211004170847.3f92ef48@thinkpad>
        <0b1bc2d7-6e62-5adb-5aed-48b99770d80d@gmail.com>
X-Mailer: Claws Mail 3.18.0 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello Jacek,

On Tue, 5 Oct 2021 21:58:13 +0200
Jacek Anaszewski <jacek.anaszewski@gmail.com> wrote:

> Hi Marek,
>=20
> On 10/4/21 5:08 PM, Marek Beh=C3=BAn wrote:
> > On Mon, 4 Oct 2021 16:50:09 +0200
> > Andrew Lunn <andrew@lunn.ch> wrote:
> >  =20
> >>> Hello Andrew,
> >>>
> >>> I am aware of this, and in fact am working on a proposal for an
> >>> extension of netdev LED extension, to support the different link
> >>> modes. (And also to support for multi-color LEDs.)
> >>>
> >>> But I am not entirely sure whether these different link modes should =
be
> >>> also definable via device-tree. Are there devices with ethernet LEDs
> >>> dedicated for a specific speed? (i.e. the manufacturer says in the
> >>> documentation of the device, or perhaps on the device's case, that th=
is
> >>> LED shows 100M/1000M link, and that other LED is shows 10M link?)
> >>> If so, that this should be specified in the devicetree, IMO. But are
> >>> such devices common? =20
> >>
> >> I have a dumb 5 port switch next to me. One port is running at 1G. Its
> >> left green LED is on and blinks with traffic. Another port of the
> >> switch is running at 100Mbps and its right orange LED is on, blinks
> >> for traffic. And there is text on the case saying 10/100 orange, 1G
> >> green.
> >>
> >> I think this is pretty common. You generally do want to know if 10/100
> >> is being used, it can indicate problems. Same for a 10G port running
> >> at 1G, etc. =20
> >=20
> > OK then. I will work no a proposal for device tree bindings for this.
> >  =20
> >>> And what about multi-color LEDs? There are ethernet ports where one L=
ED
> >>> is red-green, and so can generate red, green, and yellow color. Should
> >>> device tree also define which color indicates which mode? =20
> >>
> >> There are two different ways this can be implemented. There can be two
> >> independent LEDs within the same package. So you can generate three
> >> colours. Or there can be two cross connected LEDs within the
> >> package. Apply +ve you get one colour, apply -ve you get a different
> >> colour. Since you cannot apply both -ve and +ve at the same time, you
> >> cannot get both colours at once.
> >>
> >> If you have two independent LEDs, I would define two LEDs in DT. =20
> >=20
> > No, we have multicolor LED API which is meant for exactly this
> > situation: a multicolor LED. =20
>=20
> Multicolor LED framework is especially useful for the arrangements
> where we want to have a possibility of controlling mixed LED color
> in a wide range.
> In the discussed case it seems that having two separate LED class
> devices will be sufficient. Unless the LEDs have 255 or so possible
> brightness levels each and they can produce meaningful mixed color
> per some device state.

In the discussed case (ethernet PHY LEDs) - it is sometimes possible to
have multiple brightness levels per color channel. For example some
Marvell PHYs allow to set 8 levels of brightness for Dual Mode LEDs.
Dual Mode is what Marvell calls when the PHY allows to pair two
LED pins to control one dual-color LED (green-red, for example) into
one.

Moreover for this Dual Mode case they also allow for HW control of
this dual LED, which, when enabled, does something like this, in HW:
  1g link	green
  100m link	yellow
  10m link	red
  no link	off

Note that actual colors depend on the LEDs themselves. The PHY
documentation does not talk about the color, only about which pin is
on/off. The thing is that if we want to somehow set this mode for the
LED, it should be represented as one LED class device.

I want to extend the netdev trigger to support such configuration,
so that when you have multicolor LED, you will be able to say which
color should be set for which link mode.

> > (I am talking about something like the KJ2518D-262 from
> >   http://www.rego.com.tw/product_detail.php?prdt_id=3D258
> >   which has Green/Orange on left and Yellow on right side.
> >   The left Green/Orange LED has 3 pins, and so it can mix the colors in=
to
> >   yellow.)
> >  =20
> >> Things get tricky for the two dependency LEDs. Does the LED core have
> >> support for such LEDs? =20
> >=20
> > Unfortunately not yet. The multicolor API supports LEDs where the
> > sub-leds are independent. =20
>=20
> What do you mean by dependency here? You can write LED multicolor class
> driver that will aggregate whatever LEDs you want, provided that it will
> know how to control them. However, the target use case was RGB LED
> controllers.

Andrew explain in another reply, basically LEDs where you can choose
between, for example: OFF, green, yellow (but not both green and
yellow, because the wiring does not allow this).

The current MC framework does not work with this - unless we make it
return -EOPNOTSUPP when user does
  echo 1 1 >multi_intensity
(so that only "0 0", "0 1" and "1 0" are allowed).

Also registering this green-yellow LED as two LED classdevs is
insufficient, since setting brightness to 1 on both won't work. Only
one can be enabled.

I think the better solution here would be to have another subclass,
where you can set brightness, and color from a list of available colors.

Marek
