Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EBCC04203F8
	for <lists+netdev@lfdr.de>; Sun,  3 Oct 2021 22:53:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231686AbhJCUzb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 3 Oct 2021 16:55:31 -0400
Received: from mail.kernel.org ([198.145.29.99]:35630 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231389AbhJCUza (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 3 Oct 2021 16:55:30 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 869B861351;
        Sun,  3 Oct 2021 20:53:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1633294422;
        bh=LVnGsdHgFry4gvPG4cX/v4LbZx//84vGhu9+mdAQeOw=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=IAgx+8gJyb5LuLcgsNfPG+xZ3FsPs1DbzC09MK2+6cLN8q2VvQRAlek6m2rscKBx6
         gyPJktkzDzTw1QnRrAZ35p1niNJeex/pUuHoJy3zrU5N9ScA/aSC1olJLpoZkW9nVA
         kCoragpFTdlGR7vvW/fVLuEUSoaimMd9Hhs0UrQiKPW/s2Hco0p6A2Mj1pkv/vsNyN
         BAMZuR8H43AMbA7iRZrG50nVcWdrYUOoAMD/cUyP5ZIynYfADF9H2VCY865D2sGSIe
         d/3xeutrDn40QrA9jW5vQ17hmCBn9ll1Gzwy5lmw+1svhK4z23htme8FWuCmuy5K/h
         lokKinLe0xGUA==
Date:   Sun, 3 Oct 2021 22:53:38 +0200
From:   Marek =?UTF-8?B?QmVow7pu?= <kabel@kernel.org>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     Andrew Lunn <andrew@lunn.ch>, Pavel Machek <pavel@ucw.cz>,
        "linux-leds@vger.kernel.org" <linux-leds@vger.kernel.org>,
        netdev@vger.kernel.org,
        Jacek Anaszewski <jacek.anaszewski@gmail.com>,
        linux-kernel@vger.kernel.org
Subject: are device names part of sysfs ABI? (was Re: devicename part of
 LEDs under ethernet MAC / PHY)
Message-ID: <20211003225338.76092ec3@thinkpad>
In-Reply-To: <20211001144053.3952474a@thinkpad>
References: <20211001133057.5287f150@thinkpad>
        <YVb/HSLqcOM6drr1@lunn.ch>
        <20211001144053.3952474a@thinkpad>
X-Mailer: Claws Mail 3.18.0 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello Greg,

could you give your opinion on this discussion?

Are device names (as returned by dev_name() function) also part of
sysfs ABI? Should these names be stable across reboots / kernel
upgrades?

Marek

On Fri, 1 Oct 2021 14:40:53 +0200
Marek Beh=C3=BAn <kabel@kernel.org> wrote:

> On Fri, 1 Oct 2021 14:29:17 +0200
> Andrew Lunn <andrew@lunn.ch> wrote:
>=20
> > > - Andrew proposed that the numbering should start at non-zero number,
> > >   for example at 42, to prevent people from thinking that the numbers
> > >   are related to numbers in network interface names (ethN).
> > >   A system with interfaces
> > >     eth0
> > >     eth1
> > >   and LEDs
> > >     ethphy0:green:link
> > >     ethphy1:green:link
> > >   may make user think that the ethphy0 LED does correspond to eth0
> > >   interface, which is not necessarily true.
> > >   Instead if LEDs are
> > >     ethphy42:green:link
> > >     ethphy43:green:link=20
> > >   the probability of confusing the user into relating them to network
> > >   interfaces by these numbers is lower.
> > >=20
> > > Anyway, the issue with these naming is that it is not stable. Upgradi=
ng
> > > the kernel, enabling drivers and so on can change these names between
> > > reboots.   =20
> >=20
> > Sure, eth0 can become eth1, eth1 can become eth0. That is why we have
> > udev rules, systemd interface names etc. Interface names have never
> > been guaranteed to be stable. Also, you can have multiple interfaces
> > named eth0, so long as they are in different network name spaces.
> >  =20
> > > Also for LEDs on USB ethernet adapters, removing the USB and
> > > plugging it again would change the name, although the device path does
> > > not change if the adapter is re-plugged into the same port.
> > >=20
> > > To finally settle this then, I would like to ask your opinion on
> > > whether this naming of LEDs should be stable.   =20
> >=20
> > No. They should be unstable like everything else. =20
>=20
> LED classdev names are something different.
> For etherent interfaces, the interface name is different from name of
> the underlying struct device. But LED classdev names are also
> corresponding struct device names, and thus part of sysfs ABI, which,
> as far as I understand, should be stable.
