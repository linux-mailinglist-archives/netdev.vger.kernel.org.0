Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 577F43989EF
	for <lists+netdev@lfdr.de>; Wed,  2 Jun 2021 14:44:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230116AbhFBMqc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 2 Jun 2021 08:46:32 -0400
Received: from mail.kernel.org ([198.145.29.99]:33784 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230097AbhFBMqb (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 2 Jun 2021 08:46:31 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id ABB38613B8;
        Wed,  2 Jun 2021 12:44:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1622637888;
        bh=mY9aru4I5jdUUWZCv3k0iPOk0GIOpJClPDnCv3XBDEQ=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=Et463j64ps/dUobh8R14kaIEgDuQcOVfTqO8FXPiAYSWU2K8HszAmgi8yQFsSt423
         fpP0wYjvOEXlMNuFb3iHXfvQqoFfTyZbYA6pv8P+u4Zhr6qP2+0iOwzQjNh9jUeHz6
         F28XcMf/0RP1LnP56WO0bvaQYYpI2VaZECsDdzQTr842VTCMJ9TvVdyA2py+yVdbYl
         4zrrKHV2LOb/eub7+mj4rPUdU80d0+hJVtuPYujbTVJePRpGXkcLsj3JD01u3DFL5O
         xVMyZMFpFYKRGG2zavWHb3u1P5zJUcLCxEFobYygssZtiw/WoVMjGXM6TJCxkibIea
         /G2L43TCfQYqA==
Date:   Wed, 2 Jun 2021 14:44:39 +0200
From:   Marek =?UTF-8?B?QmVow7pu?= <kabel@kernel.org>
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     linux-leds@vger.kernel.org, netdev@vger.kernel.org,
        Pavel Machek <pavel@ucw.cz>, Dan Murphy <dmurphy@ti.com>,
        Russell King <linux@armlinux.org.uk>,
        Matthias Schiffer <matthias.schiffer@ew.tq-group.com>,
        Jacek Anaszewski <jacek.anaszewski@gmail.com>,
        Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
Subject: Re: [PATCH leds v2 06/10] leds: core: inform trigger that it's
 deactivation is due to LED removal
Message-ID: <20210602144439.4d20b295@dellmb>
In-Reply-To: <YLai2aHKKKqwRysm@lunn.ch>
References: <20210601005155.27997-1-kabel@kernel.org>
        <20210601005155.27997-7-kabel@kernel.org>
        <YLai2aHKKKqwRysm@lunn.ch>
X-Mailer: Claws Mail 3.17.8 (GTK+ 2.24.32; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 1 Jun 2021 23:12:57 +0200
Andrew Lunn <andrew@lunn.ch> wrote:

> On Tue, Jun 01, 2021 at 02:51:51AM +0200, Marek Beh=C3=BAn wrote:
> > Move setting of the LED_UNREGISTERING before deactivating the
> > trigger in led_classdev_unregister().
> >=20
> > It can be useful for a LED trigger to know whether it is being
> > deactivated due to the LED being unregistered. This makes it
> > possible for LED drivers which implement trigger offloading to
> > leave the LED in HW triggering mode when the LED is unregistered,
> > instead of disabling it. =20
>=20
> Humm, i'm not sure that is a good idea. I don't expect my Ethernet
> switch to keep forwarding frames when i unload the driver.

We want to make it so that when leds-turris-omnia driver is unloaded,
the LEDs will start blinking in HW mode as they did before the driver
was loaded. This is needed for that.

Marek
