Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9B867349B4F
	for <lists+netdev@lfdr.de>; Thu, 25 Mar 2021 21:55:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229581AbhCYUyi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 25 Mar 2021 16:54:38 -0400
Received: from mail.kernel.org ([198.145.29.99]:49356 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229930AbhCYUyT (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 25 Mar 2021 16:54:19 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 78896600EF;
        Thu, 25 Mar 2021 20:54:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1616705658;
        bh=04qLhpBg1E3LoqrE/TE98xJVRnzQ4qDRakq+V0Uffq0=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=C4NinMHk6tUCcEjO9pfJBjtwAGYjUrnx3wl7VUigkpS7ANmTRJEZw6KjHE8jv0VCh
         ppC9S2m2+xx6ylambaFnpOP3c9reJwHawZmnqQygxKH2RAH/zodwHKmw+EU+OCRaNW
         Z2nhl32QScdt5f2oPVwYs5PSh00lGvHzbZWx5vtFIyk9G/0Is8orI5TfnDu3EO3vfb
         q4DjHBUPIFN5OmSYCVmuuKO7VLldRdte/8mlM3m5s08K+6WUvaOFzkdq12XNmbJT/R
         HWM1vt/gPqOt5dArWIQ5y/pQO5zBtGW8AFsYK51UAtBy0rUyc4ftx2MLI8fVZot81o
         V5JcyTUmIt+5g==
Date:   Thu, 25 Mar 2021 21:54:14 +0100
From:   Marek =?UTF-8?B?QmVow7pu?= <kabel@kernel.org>
To:     Heiner Kallweit <hkallweit1@gmail.com>
Cc:     Russell King - ARM Linux admin <linux@armlinux.org.uk>,
        netdev@vger.kernel.org, Andrew Lunn <andrew@lunn.ch>,
        "David S . Miller" <davem@davemloft.net>,
        Florian Fainelli <f.fainelli@gmail.com>, kuba@kernel.org
Subject: Re: [PATCH net-next v2 11/12] net: phy: marvell10g: print exact
 model
Message-ID: <20210325215414.23fffe6c@thinkpad>
In-Reply-To: <418e86fb-dd7b-acbb-e648-1641f06b254b@gmail.com>
References: <20210325131250.15901-1-kabel@kernel.org>
        <20210325131250.15901-12-kabel@kernel.org>
        <20210325155452.GO1463@shell.armlinux.org.uk>
        <20210325212905.3d8f8b39@thinkpad>
        <418e86fb-dd7b-acbb-e648-1641f06b254b@gmail.com>
X-Mailer: Claws Mail 3.17.8 (GTK+ 2.24.32; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 25 Mar 2021 21:44:21 +0100
Heiner Kallweit <hkallweit1@gmail.com> wrote:

> On 25.03.2021 21:29, Marek Beh=C3=BAn wrote:
> > On Thu, 25 Mar 2021 15:54:52 +0000
> > Russell King - ARM Linux admin <linux@armlinux.org.uk> wrote:
> >  =20
> >> The 88X3310 and 88X3340 can be differentiated by bit 3 in the revision.
> >> In other words, 88X3310 is 0x09a0..0x09a7, and 88X3340 is
> >> 0x09a8..0x09af. We could add a separate driver structure, which would
> >> then allow the kernel to print a more specific string via standard
> >> methods, like we do for other PHYs. Not sure whether that would work
> >> for the 88X21x0 family though. =20
> >=20
> > According to release notes it seems that we can also differentiate
> > 88E211X from 88E218X (via bit 3 in register 1.3):
> >  88E211X has 0x09B9
> >  88E218X has 0x09B1
> >=20
> > but not 88E2110 from 88E2111
> >     nor 88E2180 from 88E2181.
> >=20
> > These can be differentiated via register
> >   3.0004.7
> > (bit 7 of MDIO_MMD_PCS.MDIO_SPEED., which says whether device is capable
> >  of 5g speed)
> >  =20
>=20
> If the PHY ID's are the same but you can use this register to
> differentiate the two versions, then you could implement the
> match_phy_device callback. This would allow you to have separate
> PHY drivers. This is just meant to say you have this option, I don't
> know the context good enough to state whether it's the better one.

Nice, didn't know about that. But I fear whether this would always work
for the 88X3310 vs 88X3310P, it is possible that this feature is only
recognizable if the firmware in the PHY is already running.

I shall look into this.

Marek
